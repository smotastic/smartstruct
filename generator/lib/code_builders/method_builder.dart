import 'dart:collection';

import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/code_builders/parameter_copy.dart';
import 'package:smartstruct_generator/models/RefChain.dart';
import 'package:smartstruct_generator/models/source_assignment.dart';
import 'package:smartstruct_generator/mapper_config.dart';
import 'package:source_gen/source_gen.dart';

import 'assignment_builder.dart';

/// Generates the implemented mapper method by the given abstract [MethodElement].
Method buildMapperImplementation(Map<String, dynamic> config,
    MethodElement method, ClassElement abstractMapper) {
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
    ..body = _generateBody(config, method, abstractMapper)
    ..returns =
        refer(method.returnType.getDisplayString(withNullability: true)));
}


/// Generates the implemented mapper method by the given abstract [MethodElement].
Method buildStaticMapperImplementation(Map<String, dynamic> config,
    MethodElement method, ClassElement abstractMapper) {
  return Method(
        (b) => b
      ..name = '_\$${method.name}'
      ..requiredParameters.addAll(method.parameters.map((e) => copyParameter(e)))
      ..body = _generateBody(config, method, abstractMapper)
      ..returns =
      refer(method.returnType.getDisplayString(withNullability: true)),
  );
}


/// Generates the body for the mapping method.
///
/// Uses the default constructor of the target mapping class to populate optional and required named and positional parameters.
/// If the target class has any properties which were not set in the constructor, and are mappable by the source, they will be also mapped after initializing the target instance.
Code _generateBody(Map<String, dynamic> config, MethodElement method,
    ClassElement abstractMapper) {
  final blockBuilder = BlockBuilder();

  final targetClass = method.returnType.element as ClassElement;

  final sourceParams = method.parameters;

  final _ = _targetToSource(sourceParams, targetClass, method, config);
  final targetToSource = _[0];
  // final customTargetToSource = _[1];

  final targetConstructor = _chooseConstructor(targetClass);
  final positionalArgs = <Expression>[];
  final namedArgs = <String, Expression>{};

  // fills namedArgs and positionalArgs for the targetConstructor if
  // one of the inputfields matches the current constructorfield
  targetConstructor.parameters
      .where((targetField) => targetToSource.containsKey(targetField.name))
      .forEach((targetField) {
    final sourceAssignment = targetToSource[targetField.name]!;
    var sourceFieldAssignment = generateSourceFieldAssignment(
        sourceAssignment, abstractMapper, targetField);

    if (targetField.isNamed) {
      namedArgs.putIfAbsent(targetField.name, () => sourceFieldAssignment);
    } else {
      positionalArgs.add(sourceFieldAssignment);
    }
    targetToSource.remove(targetField.name);
  });

  var targetVarName = targetClass.displayName.toLowerCase();

  // source.isOptional does not work
  for (final sourceParam in sourceParams) {
    if (sourceParam.type
        .getDisplayString(withNullability: true)
        .endsWith('?')) {
      blockBuilder.addExpression(
          refer('if (${sourceParam.displayName} == null) { return null; }'));
    }
  }
  // final output = Output(positionalArgs, {namedArgs});
  blockBuilder.addExpression(refer(targetConstructor.displayName)
      .newInstance(positionalArgs, namedArgs)
      .assignFinal(targetVarName));

  // non final properties (implicit and explicit setters)
  final fields = _findFields(targetClass);
  fields //
      .where((field) => !field.isFinal) //
      .where(
          (targetField) => targetToSource.containsKey(targetField.displayName))
      .map((targetField) {
    var sourceAssignment = targetToSource[targetField.displayName]!;
    var sourceFieldAssignment = generateSourceFieldAssignment(
        sourceAssignment, abstractMapper, targetField);
    return refer(targetVarName)
        .property(targetField.displayName)
        .assign(sourceFieldAssignment);
  }).forEach((expr) => blockBuilder.addExpression(expr));

  blockBuilder.addExpression(refer(targetVarName).returned);
  return blockBuilder.build();
}

/// Chooses the constructor which will be used to instantiate the target class.
ConstructorElement _chooseConstructor(ClassElement outputClass) {
  ConstructorElement chosen =
      outputClass.constructors.where((element) => !element.isFactory).first;
  for (var con in outputClass.constructors) {
    if (con.parameters.length >= chosen.parameters.length) {
      // choose the one with the most parameters
      chosen = con;
    }
  }
  return chosen;
}

List<FieldElement> _findFields(ClassElement clazz) {
  final allSuperclasses = clazz.allSupertypes
      .map((e) => e.element)
      .where((element) => !element.isDartCoreObject)
      .toList();

  final allAccessors = allSuperclasses.map((e) => e.accessors).expand((e) => e);
  final accessorMap = {for (var e in allAccessors) e.displayName: e};

  // ignore: prefer_function_declarations_over_variables
  final fieldFilter = (FieldElement field) {
    var isAbstract = false;
    // fields, who can also be getters, are never abstract, only their PropertyAccessorElement (implicit getter)
    if (accessorMap.containsKey(field.displayName)) {
      final accessor = accessorMap[field.displayName]!;
      isAbstract = accessor.isAbstract;
    }
    return !field.isStatic && !field.isConst && !isAbstract;
  };

  final allSuperFields = allSuperclasses
      .map((e) => e.fields)
      .expand((e) => e)
      .where(fieldFilter)
      .toList();
  return [...clazz.fields, ...allSuperFields];
}

List<HashMap<String, SourceAssignment>> _targetToSource(
    List<ParameterElement> sources,
    ClassElement target,
    MethodElement method,
    Map<String, dynamic> config) {
  final caseSensitiveFields = config['caseSensitiveFields'];
  final fieldMapper = caseSensitiveFields ? (a) => a : (a) => a.toUpperCase();
  equalsHashCode(a)  => fieldMapper(a).hashCode;
  final mappingConfig = MapperConfig.readMappingConfig(method);

  /// With HashMap you can specify how to compare keys
  /// It is very usefull when you want to have caseInsensitive keys
  /// Contains data from @Mapping annotations
  var targetToSource = HashMap<String, SourceAssignment>(
      equals: (a, b) => fieldMapper(a) == fieldMapper(b),
      hashCode: (a) => equalsHashCode(a));
  final mappingConfigKeySet = HashSet<String>(
      equals: (a, b) => fieldMapper(a) == fieldMapper(b),
      hashCode: (a) => equalsHashCode(a));
  mappingConfigKeySet.addAll(mappingConfig.keys);

  _collectDirectMapping(targetToSource, sources, mappingConfigKeySet);
  _collectConfigMapping(targetToSource, sources, mappingConfig);
  return [targetToSource];
}

_collectDirectMapping(
  Map<String, SourceAssignment> targetToSource,
  List<ParameterElement> sources,
  Set<String> mappingConfigKeySet,
) {

  final sourceMap = {for (var e in sources) e.type.element as ClassElement: e};

  for (final sourceEntry in sourceMap.entries) {
    for (var f in _findFields(sourceEntry.key)) {
      // The target field is binded by annotation 'Mapping'. The direct mapping is skiped.
      if(mappingConfigKeySet.contains(f.name)) {
        continue;
      }

      _checkDuplicatedKey(targetToSource, f.name);

      targetToSource[f.name] =
          SourceAssignment.fromRefChain(RefChain([sourceEntry.value, f]));
    }
  }
}

_collectConfigMapping(
  Map<String, SourceAssignment> targetToSource,
  List<ParameterElement> sources,
  Map<String, MappingConfig> mappingConfig, 
) {
  /// If there are Mapping Annotations on the method, the source attribute of the source mapping class,
  /// will be replaced with the source attribute of the given mapping config.
  mappingConfig.forEach((targetField, mappingConfig) {
    _checkDuplicatedKey(targetToSource, targetField);

    if (mappingConfig.ignore) {
      targetToSource.remove(targetField);
      return;
    }

    final sourceField = mappingConfig.source;
    if (sourceField != null) {
      if (sourceField.toFunctionValue() != null) {
        targetToSource[targetField] = SourceAssignment.fromFunction(
            sourceField.toFunctionValue()!, [...sources]);
      } else if (sourceField.toStringValue() != null) {
        final refChain = _createChainRefFromString(sources, sourceField.toStringValue()!);
        targetToSource[targetField] = SourceAssignment.fromRefChain(refChain);
      }
    }
  });
}

_checkDuplicatedKey(
  Map<String, SourceAssignment> targetToSource,
  String name,
) {
  if (targetToSource.containsKey(name)) {
        final duplicatedKey = targetToSource.keys
            .toList()
            .firstWhere((k) => k.toUpperCase() == name.toUpperCase());
    throw InvalidGenerationSourceError(
        'Mapper got case insensitive fields and contains fields: $name and $duplicatedKey. If you use a case-sensitive mapper, make sure the fields are unique in a case insensitive way.',
        todo: "Use case sensitive mapper or change field's names");
  }
}

_createChainRefFromString(List<ParameterElement> sources, String refString) {
  if(refString.isEmpty) {
    throw InvalidGenerationSourceError(
      'The ref length is 0!'
    );
  }

  final names = refString.split('.');
  final findSources = sources.where((element) => element.name == names.first);
  return findSources.isNotEmpty ?
    RefChain.byPropNames(findSources.first, names.skip(1)) :
    // If the start of the 'refString' is not the source name,
    // use the first source in the source list by default.
    RefChain.byPropNames(sources.first, names);
}