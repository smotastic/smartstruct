import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct/annotations.dart';
import 'package:source_gen/source_gen.dart';

class MapperGenerator extends GeneratorForAnnotation<Mapper> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '${element.displayName} is not a class and cannot be annotated with @Mapper',
          element: element,
          todo: 'Add Mapper annotation to a class');
    }

    final classElement = element as ClassElement;

    final mapperImpl = Class(
      (b) => b
        ..name = '${element.displayName}Impl'
        ..extend = refer('${element.displayName}')
        ..methods.addAll(classElement.methods
            .where((element) => element.isAbstract)
            .map((e) => _generateMapperMethod(e))),
    );
    final emitter = DartEmitter();
    return '${mapperImpl.accept(emitter)}';
  }

  Method _generateMapperMethod(MethodElement method) {
    if (method.returnType.element == null) {
      throw InvalidGenerationSourceError(
          '${method.returnType} is not a valid return type',
          element: method,
          todo: 'Add valid return type to mapping method');
    }
    return Method((b) => b
      ..annotations.add(CodeExpression(Code('override')))
      ..name = method.displayName
      ..requiredParameters
          .addAll(method.parameters.map((e) => _generateParameter(e)))
      ..body = _generateBody(method)
      ..returns = refer(method.returnType.element!.displayName));
  }

  Code _generateBody(MethodElement method) {
    final input = method.parameters.first;
    final outputClass = method.returnType.element as ClassElement;
    final inputClass = input.type.element as ClassElement;
    final inputReference = refer(input.displayName);

    final usedConstructor =
        outputClass.constructors.where((element) => !element.isFactory).first;

    final inputFields = <String, FieldElement>{};
    inputClass.fields
        .forEach(((e) => inputFields.putIfAbsent(e.name, () => e)));

    // For Accessing the properties of the input
    // [model.id, model.name,...]
    final positionalArgs =
        usedConstructor.parameters.where((e) => !e.isNamed).map((field) {
      // one of the inputfields matches the current constructorfield
      if (inputFields.containsKey(field.name)) {
        return inputReference.property(field.name);
      }
      // else we cannot handle and it is unknown to us
      return literal(null);
    });

    var namedArgs = <String, Expression>{};
    usedConstructor.parameters.where((e) => e.isNamed).forEach((field) {
      if (inputFields.containsKey(field.name)) {
        namedArgs.putIfAbsent(
            field.name, () => inputReference.property(field.name));
      }
    });
    final blockBuilder = BlockBuilder()
      ..addExpression(refer(outputClass.displayName)
          .newInstance(positionalArgs, namedArgs)
          .returned);

    // final setters = to.fields.where((element) => element.setter != null);

    return blockBuilder.build();
  }

  Parameter _generateParameter(ParameterElement e) {
    if (e.type.element == null) {
      throw InvalidGenerationSourceError(
          '${e.type} is not a valid parameter type',
          element: e,
          todo: 'Add valid parameter type to mapping parameters');
    }
    return Parameter((b) => b
      ..name = e.name
      ..type = refer(e.type.element!.displayName));
  }
}
