import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/models/source_assignment.dart';

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
Expression generateSourceFieldAssignment(SourceAssignment sourceAssignment,
    ClassElement abstractMapper, VariableElement targetField) {
  Expression sourceFieldAssignment;

  if (sourceAssignment.shouldUseFunction()) {
    final sourceFunction = sourceAssignment.function!;
    final references = sourceAssignment.params!
        .map((sourceParam) => refer(sourceParam.displayName));
    Expression expr = refer(sourceFunction.name);
    if (sourceFunction.isStatic &&
        sourceFunction.enclosingElement.name != null) {
      expr = refer(sourceFunction.enclosingElement.name!)
          .property(sourceFunction.name);
    }
    sourceFieldAssignment = expr.call([...references], makeNamedArgumentForStaticFunction(sourceFunction));

    // The return of the function may be needed a nested mapping.
    sourceFieldAssignment = invokeNestedMappingForStaticFunction(
      sourceFunction, 
      abstractMapper, 
      targetField, 
      sourceFieldAssignment);
  } else {
    // final sourceClass = sourceAssignment.sourceClass!;
    final sourceField = sourceAssignment.field!;
    final sourceReference = refer(sourceAssignment.sourceName!);
    sourceFieldAssignment = sourceReference.property(sourceField.name);
    // list support
    if (sourceAssignment.shouldAssignList()) {
      final sourceListType = _getGenericTypes(sourceField.type).first;
      final targetListType = _getGenericTypes(targetField.type).first;
      final matchingMappingListMethods = _findMatchingMappingMethod(
          abstractMapper, targetListType, sourceListType);

      // mapping expression, default is just the identity,
      // for example for primitive types or objects that do not have their own mapping method
      var expr = refer('(e) => e');
      var sourceIsNullable = sourceListType.nullabilitySuffix == NullabilitySuffix.question;
      var targetIsNullable = targetListType.nullabilitySuffix == NullabilitySuffix.question; 
      var needTargetFilter = sourceIsNullable && !targetIsNullable;
      if (matchingMappingListMethods.isNotEmpty) {
        final nestedMapping = matchingMappingListMethods.first;
        // expr = refer(nestedMapping.name);
        final invokeStr = invokeNestedMappingFunction(
          nestedMapping, 
          sourceIsNullable, 
          refer("x"), 
          refer("x"),
        ).accept(DartEmitter()).toString();
        expr = refer('''
          (x) => $invokeStr
        ''');
        final returnIsNullable = checkNestMappingReturnNullable(nestedMapping, sourceIsNullable);
        needTargetFilter = !targetIsNullable && returnIsNullable; 
      }

      sourceFieldAssignment =
          // source.{field}.map
        sourceReference.property(sourceField.name)
        .property('map')
        // (expr)
        .call([expr]);

      if(needTargetFilter) {
        sourceFieldAssignment = sourceFieldAssignment.property("where").call([refer("(x) => x != null")]);
      }

      sourceFieldAssignment = sourceFieldAssignment
        //.toList()
        .property('toList')
        .call([]);
      if(needTargetFilter) {
        sourceFieldAssignment = sourceFieldAssignment
          .asA(refer(targetField.type.getDisplayString(withNullability: true)));
      }
    } else {
      // found a mapping method in the class which will map the source to target
      final matchingMappingMethods = _findMatchingMappingMethod(
          abstractMapper, targetField.type, sourceField.type);

      // nested classes can be mapped with their own mapping methods
      if (matchingMappingMethods.isNotEmpty) {
        sourceFieldAssignment = invokeNestedMappingFunction(
          matchingMappingMethods.first, 
          sourceAssignment.refChain!.isNullable,
          refer(sourceAssignment.refChain!.refWithQuestion),
          refer(sourceAssignment.refChain!.ref),
        );
      }
    }
  }
  return sourceFieldAssignment;
}

Expression invokeNestedMappingFunction(
  MethodElement method, 
  bool sourceNullable,
  Expression refWithQuestion,
  Expression ref,
) {
  Expression sourceFieldAssignment;
  if(method.parameters.first.isOptional) {
    // The parameter can be null.
    sourceFieldAssignment = refer(method.name)
        .call([refWithQuestion]);
  } else {
    sourceFieldAssignment = refer(method.name)
        .call([ref]);
    sourceFieldAssignment = checkNullExpression(
      sourceNullable,
      refWithQuestion, 
      sourceFieldAssignment
    );
  }
  return sourceFieldAssignment;
}

Expression invokeNestedMappingForStaticFunction(
  ExecutableElement sourceFunction,
  ClassElement abstractMapper,
  VariableElement targetField,
  Expression sourceFieldAssignment,
) {
  final returnType = sourceFunction.returnType;
  final matchingMappingMethods = _findMatchingMappingMethod(
      abstractMapper, targetField.type, returnType);
  if(matchingMappingMethods.isNotEmpty) {
    final nestedMappingMethod = matchingMappingMethods.first;

    if(
      nestedMappingMethod.parameters.first.type.nullabilitySuffix != NullabilitySuffix.question &&
      sourceFunction.returnType.nullabilitySuffix == NullabilitySuffix.question
    ) {
      final str = makeNullCheckCall(
        sourceFieldAssignment.accept(
          DartEmitter()
        ).toString(),
        nestedMappingMethod,
      );
      sourceFieldAssignment = refer(str);
    } else {
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
    // Sometimes the user is troubled by the nullability of these types.
    // So ingore the nullability of all the type for the nested mapping function is more easy to be matched.
    // The process of nullability is one duty for this library.
    final metReturnElement = met.returnType.element;
    final metParameterElement = met.parameters.first.type.element;

    final targetReturnElement = targetReturnType.element;
    final srcParameterElement = sourceParameterType.element;

    return metReturnElement == targetReturnElement &&
        (metParameterElement == srcParameterElement);

    // return met.returnType == targetReturnType &&
    //     met.parameters.isNotEmpty && met.parameters.first.type == sourceParameterType;
  });
  return matchingMappingMethods;
}

Iterable<DartType> _getGenericTypes(DartType type) {
  return type is ParameterizedType ? type.typeArguments : const [];
}

// Sometimes we need to pass some variable to the static function just like "this pointer".
// We can use the named parameters to implement the goal.
Map<String, Expression> makeNamedArgumentForStaticFunction(ExecutableElement  element) {

    final argumentMap = {
      "mapper": "this",
      "\$this": "this",
    };
    final namedParameterList = element.parameters.where((p) => p.isNamed && argumentMap.containsKey(p.name)).toList();

    return namedParameterList
      .asMap().map((key, value) => MapEntry(
        value.name, 
        refer(argumentMap[value.name]!)
      ));
}

Expression checkNullExpression(
  bool needCheck,
  Expression sourceRef,
  Expression expression,
) {
  if(needCheck) {
    return sourceRef.equalTo(literalNull).conditional(
      literalNull, 
      expression,
    );
  } else {
    return expression;
  }
}

makeNullCheckCall(
  String checkTarget,
  MethodElement method,
) {

  final methodInvoke = refer(method.name).call([refer("tmp")]).accept(DartEmitter()).toString();
  return '''
  (){
    final tmp = $checkTarget;
    return tmp == null ? null : $methodInvoke;
  }()
''';
}

checkNestMappingReturnNullable(MethodElement method, bool inputNullable) {
  final returnIsNullable = 
    (inputNullable && 
      method.parameters.first.type.nullabilitySuffix != NullabilitySuffix.question
    ) ||
    (
      inputNullable &&
      method.returnType.nullabilitySuffix == NullabilitySuffix.question
    );
    return returnIsNullable;
}