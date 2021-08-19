import 'dart:collection';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/code_builders/parameter_copy.dart';
import 'package:smartstruct_generator/mapper_config.dart';
import 'package:source_gen/source_gen.dart';

import 'assignment_builder.dart';

/// Generates the implemented mapper method by the given abstract [MethodElement].
Method buildMapperImplementation(Map<String, dynamic> config,
    MethodElement method, ClassElement classElement) {
  if (method.returnType.element == null) {
    throw InvalidGenerationSourceError(
        '${method.returnType} is not a valid return type',
        element: method,
        todo: 'Add valid return type to mapping method');
  }
  return Method((b) => b
    ..annotations.add(CodeExpression(Code('override')))
    ..name = method.displayName
    ..requiredParameters.addAll(method.parameters.map((e) => copyParameter(e)))
    ..body = _generateBody(config, method, classElement)
    ..returns =
        refer(method.returnType.getDisplayString(withNullability: true)));
}

/// Generates the body for the mapping method.
///
/// Uses the default constructor of the target mapping class to populate optional and required named and positional parameters.
/// If the target class has any properties which were not set in the constructor, and are mappable by the source, they will be also mapped after initializing the target instance.
Code _generateBody(Map<String, dynamic> config, MethodElement method,
    ClassElement classElement) {
  final blockBuilder = BlockBuilder();

  final targetClass = method.returnType.element as ClassElement;

  final sourceParam = method.parameters.first;
  final sourceClass = sourceParam.type.element as ClassElement;
  final sourceReference = refer(sourceParam.displayName);

  final _ = _targetToSource(sourceClass, targetClass, method, config);
  final targetToSource = _[0];
  final customTargetToSource = _[1];

  final targetConstructor = _chooseConstructor(targetClass, sourceClass);
  final positionalArgs = <Expression>[];
  final namedArgs = <String, Expression>{};

  targetConstructor.parameters
      .where(
          (targetField) => customTargetToSource.containsKey(targetField.name))
      .forEach((targetField) {
    final mappingMethod = customTargetToSource[targetField.name]!;
    print(mappingMethod);
    if (mappingMethod is DartObject) {
      final func = mappingMethod.toFunctionValue();
      if (func != null) {
        var fieldAssigment = refer(func.name).call([refer(sourceParam.name)]);
        if (targetField.isNamed) {
          namedArgs.putIfAbsent(targetField.name, () => fieldAssigment);
        } else {
          positionalArgs.add(fieldAssigment);
        }
      }
    }
    customTargetToSource.remove(targetField.name);
  });

  // fills namedArgs and positionalArgs for the targetConstructor if
  // one of the inputfields matches the current constructorfield
  targetConstructor.parameters
      .where((targetField) => targetToSource.containsKey(targetField.name))
      .forEach((targetField) {
    final sourceField = targetToSource[targetField.name]!;
    var sourceFieldAssignment = generateSourceFieldAssignment(
        sourceReference, sourceField, classElement, targetField);

    if (targetField.isNamed) {
      namedArgs.putIfAbsent(targetField.name, () => sourceFieldAssignment);
    } else {
      positionalArgs.add(sourceFieldAssignment);
    }
    targetToSource.remove(targetField.name);
  });

  var targetVarName = targetClass.displayName.toLowerCase();

  // source.isOptional does not work
  if (sourceParam.type.getDisplayString(withNullability: true).endsWith('?')) {
    blockBuilder.addExpression(
        refer('if (${sourceParam.displayName} == null) { return null; }'));
  }
  // final output = Output(positionalArgs, {namedArgs});
  blockBuilder.addExpression(refer(targetClass.displayName)
      .newInstance(positionalArgs, namedArgs)
      .assignFinal(targetVarName));

  // non final properties (implicit and explicit setters)
  targetClass.fields //
      .where((field) => !field.isFinal) //
      .where(
          (targetField) => targetToSource.containsKey(targetField.displayName))
      .map((targetField) {
    var sourceField = targetToSource[targetField.displayName] as FieldElement;
    var sourceFieldAssignment = generateSourceFieldAssignment(
        sourceReference, sourceField, classElement, targetField);
    return refer(targetVarName)
        .property(targetField.displayName)
        .assign(sourceFieldAssignment);
  }).forEach((expr) => blockBuilder.addExpression(expr));

  blockBuilder.addExpression(refer(targetVarName).returned);
  return blockBuilder.build();
}

/// Chooses the constructor which will be used to instantiate the target class.
ConstructorElement _chooseConstructor(
    ClassElement outputClass, ClassElement _) {
  return outputClass.constructors.where((element) => !element.isFactory).first;
}

List<HashMap<String, dynamic>> _targetToSource(ClassElement source,
    ClassElement target, MethodElement method, Map<String, dynamic> config) {
  final caseSensitiveFields = config['caseSensitiveFields'];
  final fieldMapper = caseSensitiveFields ? (a) => a : (a) => a.toUpperCase();
  final equalsHashCode =
      caseSensitiveFields ? (a) => a.hashCode : (a) => a.toUpperCase().hashCode;
  final mappingConfig = MapperConfig.readMappingConfig(method);
  final customMappingConfig = MapperConfig.readCustomMappingConfig(method);

  /// With HashMap you can specify how to compare keys
  /// It is very usefull when you want to have caseInsensitive keys
  /// Contains data from @Mapping annotations
  var targetToSource = HashMap<String, FieldElement>(
      equals: (a, b) => fieldMapper(a) == fieldMapper(b),
      hashCode: (a) => equalsHashCode(a));

  // /// Contains data from @CustomMapping annotations
  var customTargetToSource = HashMap<String, dynamic>(
      equals: (a, b) => fieldMapper(a) == fieldMapper(b),
      hashCode: (a) => equalsHashCode(a));

  for (var f in source.fields) {
    if (targetToSource.containsKey(f.name) && !caseSensitiveFields) {
      final duplicatedKey = targetToSource.keys
          .toList()
          .firstWhere((k) => k.toUpperCase() == f.name.toUpperCase());
      throw InvalidGenerationSourceError(
          'Mapper got case insensitive fields and contains fields: ${f.name} and $duplicatedKey. If you use a case-sensitive mapper, make sure the fields are unique in a case insensitive way.',
          todo: "Use case sensitive mapper or change field's names");
    }
    targetToSource[f.name] = f;
  }

  /// If there are Mapping Annotations on the method, the source attribute of the source mapping class,
  /// will be replaced with the source attribute of the given mapping config.
  mappingConfig.forEach((sourceField, targetField) {
    if (targetToSource.containsKey(sourceField)) {
      targetToSource.putIfAbsent(
          targetField, () => targetToSource[sourceField] as FieldElement);
      targetToSource.remove(sourceField);
    }
  });

  for (var f in target.fields) {
    ///Mapped by @CustomMapping annotation
    final fieldIsCustomMapped = customMappingConfig.containsKey(f.displayName);
    if (fieldIsCustomMapped) {
      customTargetToSource[f.displayName] = customMappingConfig[f.displayName];
      if (targetToSource.containsKey(f.displayName)) {
        targetToSource.remove(f.displayName);
      }
    }
  }
  return [targetToSource, customTargetToSource];
}
