import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/code_builders/method_builder.dart';

import 'parameter_copy.dart';

Class buildMapperClass(
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
