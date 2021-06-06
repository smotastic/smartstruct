import 'package:analyzer/dart/constant/value.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct/annotations.dart';
import 'package:source_gen/source_gen.dart';

class MapperGenerator extends GeneratorForAnnotation<Mapper> {
  // DartObject getAnnotation(Element element) {
  //   final annotations =
  //       TypeChecker.fromRuntime(AnnotationType).annotationsOf(element);
  //   if (annotations.isEmpty) {
  //     return null;
  //   }
  //   if (annotations.length > 1) {
  //     throw Exception(
  //         "You tried to add multiple @$AnnotationType() annotations to the "
  //         "same element (${element.name}), but that's not possible.");
  //   }
  //   return annotations.single;
  // }

  Map<String, dynamic> readConfig(
      ConstantReader annotation, ClassElement mappingClass) {
    var mapper =
        mappingClass.metadata[0].element!.enclosingElement as ClassElement;
    final config = <String, dynamic>{};
    mapper.fields.forEach((field) {
      final configField = annotation.read(field.name).literalValue;
      config.putIfAbsent(field.name, () => configField);
    });

    return config;
  }

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

    var config = readConfig(annotation, classElement);

    final mapperImpl = Class(
      (b) => b
        ..annotations.addAll(_generateClassAnnotations(config))
        ..name = '${element.displayName}Impl'
        ..extend = refer('${element.displayName}')
        ..methods.addAll(classElement.methods
            .where((element) => element.isAbstract)
            .map((e) => _generateMapperMethod(e))),
    );
    final emitter = DartEmitter();
    return '${mapperImpl.accept(emitter)}';
  }

  Iterable<Expression> _generateClassAnnotations(Map<String, dynamic> config) {
    final ret = <Expression>[];

    if (config['useInjection']) {
      ret.add(refer('lazySingleton').newInstance([]));
    }
    return ret;
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

    final inputFields = <String, FieldElement>{};
    inputClass.fields
        .forEach(((e) => inputFields.putIfAbsent(e.name, () => e)));

    final usedConstructor = _chooseConstructor(outputClass, inputClass);
    // For Accessing the properties of the input
    // [model.id, model.name,...]
    final positionalArgs =
        usedConstructor.parameters.where((e) => !e.isNamed).map((field) {
      // one of the inputfields matches the current constructorfield
      if (inputFields.containsKey(field.name)) {
        inputFields.remove(field.name);
        return inputReference.property(field.name);
      }
      // else we cannot handle and it is unknown to us
      throw InvalidGenerationSourceError(
          'Unknown positional Argument ${field.name}',
          element: field,
          todo:
              'Add the field as a positional Argument in the constructor of the output class');
    });

    final namedArgs = <String, Expression>{};
    usedConstructor.parameters.where((e) => e.isNamed).forEach((field) {
      if (inputFields.containsKey(field.name)) {
        inputFields.remove(field.name);
        namedArgs.putIfAbsent(
            field.name, () => inputReference.property(field.name));
      }
    });

    var outputName = outputClass.displayName.toLowerCase();
    final blockBuilder = BlockBuilder()
      // final output = Output(positionalArgs, {namedArgs});
      ..addExpression(refer(outputClass.displayName)
          .newInstance(positionalArgs, namedArgs)
          .assignFinal(outputName));

    // non final properties (implicit and explicit setters)
    final mutableProperties =
        outputClass.fields.where((element) => !element.isFinal);
    for (final prop in mutableProperties) {
      if (inputFields.containsKey(prop.displayName)) {
        inputFields.remove(prop.displayName);
        blockBuilder.addExpression(refer(outputName)
            .property(prop.displayName)
            .assign(inputReference.property(prop.displayName)));
      }
    }

    blockBuilder.addExpression(refer(outputName).returned);
    return blockBuilder.build();
  }

  ConstructorElement _chooseConstructor(
      ClassElement outputClass, ClassElement inputClass) {
    return outputClass.constructors
        .where((element) => !element.isFactory)
        .first;
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
