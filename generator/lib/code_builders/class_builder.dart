import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/code_builders/method_builder.dart';
import 'package:smartstruct_generator/code_builders/static_proxy_builder.dart';
import 'parameter_copy.dart';

Library buildMapperClass(
    ClassElement abstractClass, Map<String, dynamic> config) {
  return Library((b) => b.body.addAll(
        [
          _generateMapperImplementationClass(abstractClass, config),
          ..._generateStaticMethods(abstractClass, config),
          ..._generateStaticProxy(abstractClass, config),
        ],
      ));
}

List<Class> _generateStaticProxy(
    ClassElement abstractClass, Map<String, dynamic> config) {
  if(config['static']) {
    return [generateStaticProxy(abstractClass)];
  }
  return [];
}

List<Method> _generateStaticMethods(
    ClassElement abstractClass, Map<String, dynamic> config) {
  // I have no idea why the static methods needed to be generated.
  // But if the return type is abstract class like List, the _generateBody in "method_builder.dart" can not work.
  // So we need to filter these function.
  var staticMethods = abstractClass.methods
      .where((method) => method.isStatic 
        && !_isPrimitive(method.returnType)
        && !isAbstractType(method.returnType))
      .map((method) => buildStaticMapperImplementation(config, method, abstractClass))
      .toList();
  return staticMethods;
}

bool isAbstractType(DartType type) {
    final element = type.element;
    if(element is! ClassElement) {
        return false;
    }
    return element.isAbstract; 
}

bool _isPrimitive(DartType type) {
  return type.isDartCoreBool || type.isDartCoreDouble || type.isDartCoreInt || type.isDartCoreNum || type.isDartCoreString;
}

Class _generateMapperImplementationClass(
    ClassElement abstractClass, Map<String, dynamic> config) {
  return Class(
    (b) => b
      ..annotations.addAll(_generateClassAnnotations(config, abstractClass))
      ..name = '${abstractClass.displayName}Impl'
      ..constructors.addAll(
          abstractClass.constructors.map((c) => _generateConstructor(c)))
      ..extend = refer('${abstractClass.displayName}')
      ..methods.addAll(abstractClass.methods
          .where((method) => method.isAbstract)
          .map((method) =>
              buildMapperImplementation(config, method, abstractClass))),
  );
}

/// Generates a [Constructor] by copying the given [ConstructorElement] c
Constructor _generateConstructor(ConstructorElement c) {
  final builder = ConstructorBuilder();
  if (c.name.isNotEmpty) {
    builder.name = c.name;
  }

  final namedParams = c.parameters
      .where((element) => element.isNamed)
      .map((e) => copyParameter(e));

  final positionalParams = c.parameters
      .where((element) => element.isPositional)
      .map((e) => copyParameter(e));

  builder.optionalParameters.addAll(namedParams);
  builder.requiredParameters.addAll(positionalParams);

  final namedArgs = {
    for (var f in c.parameters.where((element) => element.isNamed))
      f.name: refer(f.name)
  };

  var positionalArgs = c.parameters
      .where((element) => element.isPositional)
      .map((e) => refer(e.name));

  Expression superCall = refer('super');
  if (c.name.isNotEmpty) {
    superCall = superCall.property(c.name);
  }
  builder.initializers.add(superCall.call(positionalArgs, namedArgs).code);

  return builder.build();
}

/// Generates the Class Annotations for the created mapper implementation
///
/// If the config contains the useInjection key, a [LazySingleton] Annotation will be added to the resulting implementation of the mapper.
/// Note that the mapper interface class has to import the injectable library if this is the case.
Iterable<Expression> _generateClassAnnotations(
    Map<String, dynamic> config, ClassElement classElement) {
  final ret = <Expression>[];

  if (config['useInjection']) {
    ret.add(refer('LazySingleton')
        .newInstance([], {'as': refer(classElement.displayName)}));
  }
  return ret;
}
