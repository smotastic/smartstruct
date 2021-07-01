import 'dart:collection';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct/smartstruct.dart';
import 'package:source_gen/source_gen.dart';
import 'mapper_config.dart';

/// Codegenerator to generate implemented mapping classes
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

    var config = MapperConfig.readMapperConfig(annotation, element);

    final mapperImpl = Class(
      (b) => b
        ..annotations.addAll(_generateClassAnnotations(config, element))
        ..name = '${element.displayName}Impl'
        ..constructors
            .addAll(element.constructors.map((c) => _generateConstructor(c)))
        ..extend = refer('${element.displayName}')
        ..methods.addAll(element.methods
            .where((method) => method.isAbstract)
            .map((method) => _generateMapperMethod(config, method, element))),
    );
    final emitter = DartEmitter();
    return '${mapperImpl.accept(emitter)}';
  }

  /// Generates a [Constructor] by copying the given [ConstructorElement] c
  Constructor _generateConstructor(ConstructorElement c) {
    final builder = ConstructorBuilder();
    if (c.name.isNotEmpty) {
      builder.name = c.name;
    }

    final namedParams = c.parameters
        .where((element) => element.isNamed)
        .map((e) => _generateParameter(e));

    final positionalParams = c.parameters
        .where((element) => element.isPositional)
        .map((e) => _generateParameter(e));

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

  /// Generates the implemented mapper method by the given abstract [MethodElement].
  Method _generateMapperMethod(Map<String, dynamic> config,
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
      ..requiredParameters
          .addAll(method.parameters.map((e) => _generateParameter(e)))
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
    final source = method.parameters.first;
    final targetClass = method.returnType.element as ClassElement;

    final sourceClass = source.type.element as ClassElement;
    final sourceReference = refer(source.displayName);

    final caseSensitiveFields = config['caseSensitiveFields'];
    final fieldMapper = caseSensitiveFields ? (a) => a : (a) => a.toUpperCase();
    final equalsHashCode = caseSensitiveFields
        ? (a) => a.hashCode
        : (a) => a.toUpperCase().hashCode;
    final mappingConfig = MapperConfig.readMappingConfig(method);
    final customMappingConfig = MapperConfig.readCustomMappingConfig(method);

    /// With HashMap you can specify how to compare keys
    /// It is very usefull when you want to have caseInsensitive keys
    /// Contains data from @Mapping annotations
    var targetToSource = HashMap<String, FieldElement>(
        equals: (a, b) => fieldMapper(a) == fieldMapper(b),
        hashCode: (a) => equalsHashCode(a));

    /// Contains data from @CustomMapping annotations
    var customTargetToSource = HashMap<String, dynamic>(
        equals: (a, b) => fieldMapper(a) == fieldMapper(b),
        hashCode: (a) => equalsHashCode(a));

    for (var f in sourceClass.fields) {
      if (targetToSource.containsKey(f.name) && !caseSensitiveFields) {
        final duplicatedKey = targetToSource.keys
            .toList()
            .firstWhere((k) => k.toUpperCase() == f.name.toUpperCase());
        throw InvalidGenerationSourceError(
            'Mapper ${classElement.displayName} got case insensitive fields and contains fields: ${f.name} and $duplicatedKey. If you use a case-sensitive mapper, make sure the fields are unique in a case insensitive way.',
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

    for (var f in targetClass.fields) {
      ///Mapped by @CustomMapping annotation
      final fieldIsCustomMapped =
          customMappingConfig.containsKey(f.displayName);
      if (fieldIsCustomMapped) {
        customTargetToSource[f.displayName] =
            customMappingConfig[f.displayName];
        if (targetToSource.containsKey(f.displayName)) {
          targetToSource.remove(f.displayName);
        }
      }
    }

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
          var fieldAssigment = refer(func.name).call([refer(source.name)]);
          if (targetField.isNamed) {
            namedArgs.putIfAbsent(targetField.name, () => fieldAssigment);
          } else {
            positionalArgs.add(fieldAssigment);
          }
        }
      }
      customTargetToSource.remove(targetField.name);
    });

    // one of the inputfields matches the current constructorfield
    targetConstructor.parameters
        .where((targetField) => targetToSource.containsKey(targetField.name))
        .forEach((targetField) {
      final sourceField = targetToSource[targetField.name]!;
      var sourceFieldAssignment = _generateSourceFieldAssignment(
          sourceReference, sourceField, classElement, targetField);

      if (targetField.isNamed) {
        namedArgs.putIfAbsent(targetField.name, () => sourceFieldAssignment);
      } else {
        positionalArgs.add(sourceFieldAssignment);
      }
      targetToSource.remove(targetField.name);
    });

    var targetVarName = targetClass.displayName.toLowerCase();
    final blockBuilder = BlockBuilder();
    // source.isOptional does not work
    if (source.type.getDisplayString(withNullability: true).endsWith('?')) {
      blockBuilder.addExpression(
          refer('if (${source.displayName} == null) { return null; }'));
    }
    // final output = Output(positionalArgs, {namedArgs});
    blockBuilder.addExpression(refer(targetClass.displayName)
        .newInstance(positionalArgs, namedArgs)
        .assignFinal(targetVarName));

    // non final properties (implicit and explicit setters)
    targetClass.fields //
        .where((field) => !field.isFinal) //
        .where((targetField) =>
            targetToSource.containsKey(targetField.displayName))
        .map((targetField) {
      var sourceField = targetToSource[targetField.displayName] as FieldElement;
      var sourceFieldAssignment = _generateSourceFieldAssignment(
          sourceReference, sourceField, classElement, targetField);
      return refer(targetVarName)
          .property(targetField.displayName)
          .assign(sourceFieldAssignment);
    }).forEach((expr) => blockBuilder.addExpression(expr));

    blockBuilder.addExpression(refer(targetVarName).returned);
    return blockBuilder.build();
  }

  /// Generates an assignment of a reference to a sourcefield.
  ///
  /// The assignment is the property {sourceField} of the given [Reference] {sourceReference}.
  /// If a method in the given [ClassElement] exists,
  /// whose returntype matches the type of the targetField, and its first parameter type matches the sourceField type,
  /// then this method will be used for the assignment instead, and passing the sourceField property of the given [Reference] as the argument of the method.
  ///
  /// Returns the Expression of the sourceField assignment, such as:
  /// ```dart
  /// model.id;
  /// fromSub(model.sub);
  /// ```
  ///
  Expression _generateSourceFieldAssignment(
      Reference sourceReference,
      FieldElement sourceField,
      ClassElement classElement,
      VariableElement targetField) {
    var sourceFieldAssignment = sourceReference.property(sourceField.name);
    // list support
    if (sourceField.type.isDartCoreList ||
        sourceField.type.isDartCoreIterable) {
      final sourceListType = _getGenericTypes(sourceField.type).first;
      final targetListType = _getGenericTypes(targetField.type).first;
      final matchingMappingListMethods = _findMatchingMappingMethod(
          classElement, targetListType, sourceListType);

      // mapping expression, default is just the identity,
      // for example for primitive types or objects that do not have their own mapping method
      var expr = refer('(e) => e');
      if (matchingMappingListMethods.isNotEmpty) {
        expr = refer(matchingMappingListMethods.first.name);
      }

      sourceFieldAssignment =
          // source.{field}.map
          sourceReference
              .property(sourceField.name)
              .property('map')
              // (expr)
              .call([expr])
              //.toList()
              .property('toList')
              .call([]);
    } else {
      // found a mapping method in the class which will map the source to target
      final matchingMappingMethods = _findMatchingMappingMethod(
          classElement, targetField.type, sourceField.type);

      // nested classes can be mapped with their own mapping methods
      if (matchingMappingMethods.isNotEmpty) {
        sourceFieldAssignment = refer(matchingMappingMethods.first.name)
            .call([sourceFieldAssignment]);
      }
    }

    return sourceFieldAssignment;
  }

  /// Finds a matching Mapping Method in [classElement]
  /// which has the same return type as the given [targetReturnType] and same parametertype as the given [sourceParameterType]
  Iterable<MethodElement> _findMatchingMappingMethod(ClassElement classElement,
      DartType targetReturnType, DartType sourceParameterType) {
    final matchingMappingMethods = classElement.methods.where((met) {
      return met.returnType == targetReturnType &&
          met.parameters.first.type == sourceParameterType;
    });
    return matchingMappingMethods;
  }

  Iterable<DartType> _getGenericTypes(DartType type) {
    return type is ParameterizedType ? type.typeArguments : const [];
  }

  /// Chooses the constructor which will be used to instantiate the target class.
  ConstructorElement _chooseConstructor(
      ClassElement outputClass, ClassElement _) {
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

    return Parameter(
      (b) => b
        ..required = e.isRequiredNamed
        ..named = e.isNamed
        ..name = e.name
        ..type = refer(e.type.getDisplayString(withNullability: true))
        ..defaultTo =
            e.hasDefaultValue ? refer(e.defaultValueCode!).code : null,
    );
  }
}
