import 'package:analyzer/dart/constant/value.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct/annotations.dart';
import 'package:smartstruct/mapper_config.dart';
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

    var config = MapperConfig.readClassConfig(annotation, element);

    final mapperImpl = Class(
      (b) => b
        ..annotations.addAll(_generateClassAnnotations(config, element))
        ..name = '${element.displayName}Impl'
        ..extend = refer('${element.displayName}')
        ..methods.addAll(element.methods
            .where((element) => element.isAbstract)
            .map((e) => _generateMapperMethod(e))),
    );
    final emitter = DartEmitter();
    return '${mapperImpl.accept(emitter)}';
  }

  Iterable<Expression> _generateClassAnnotations(
      Map<String, dynamic> config, ClassElement classElement) {
    final ret = <Expression>[];

    if (config['useInjection']) {
      ret.add(refer('LazySingleton')
          .newInstance([], {'as': refer(classElement.displayName)}));
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

    final mappingConfig = MapperConfig.readMethodConfig(method);
    // wenn source dann nicht f.name sondern target
    final inputFields = {for (var f in inputClass.fields) f.name: f};
    mappingConfig.forEach((source, target) {
      if (inputFields.containsKey(source)) {
        inputFields.putIfAbsent(
            target, () => inputFields[source] as FieldElement);
      }
    });

    final usedConstructor = _chooseConstructor(outputClass, inputClass);
    final positionalArgs = <Expression>[];
    usedConstructor.parameters
        .where((field) => !field.isNamed)
        // one of the inputfields matches the current constructorfield
        .where((field) => inputFields.containsKey(field.name))
        .map((e) => inputFields[e.name]
            as FieldElement) // explicit cast because of nullsafety
        .forEach((field) {
      // [model.id, model.name,...]
      positionalArgs.add(inputReference.property(field.name));
      inputFields.remove(field.name);
    });

    final namedArgs = <String, Expression>{};
    usedConstructor.parameters
        .where((field) => field.isNamed)
        // one of the inputfields matches the current constructorfield
        .where((field) => inputFields.containsKey(field.name))
        .forEach((field) {
      namedArgs.putIfAbsent(field.name,
          () => inputReference.property(inputFields[field.name]!.name));
      inputFields.remove(field.name);
    });

    var outputName = outputClass.displayName.toLowerCase();
    final blockBuilder = BlockBuilder()
      // final output = Output(positionalArgs, {namedArgs});
      ..addExpression(refer(outputClass.displayName)
          .newInstance(positionalArgs, namedArgs)
          .assignFinal(outputName));

    // non final properties (implicit and explicit setters)
    outputClass.fields //
        .where((field) => !field.isFinal) //
        .where((field) => inputFields.containsKey(field.displayName))
        .map((field) => refer(outputName).property(field.displayName).assign(
            inputReference
                .property(inputFields[field.displayName]!.displayName)))
        .forEach((expr) => blockBuilder.addExpression(expr));

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
