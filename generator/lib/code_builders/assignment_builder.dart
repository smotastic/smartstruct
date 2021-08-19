import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

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
Expression generateSourceFieldAssignment(
    Reference sourceReference,
    FieldElement sourceField,
    ClassElement classElement,
    VariableElement targetField) {
  var sourceFieldAssignment = sourceReference.property(sourceField.name);
  // list support
  if (sourceField.type.isDartCoreList || sourceField.type.isDartCoreIterable) {
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
