import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/code_builders/list_assignment_builder.dart';
import 'package:smartstruct_generator/models/source_assignment.dart';

import './nested_mapping_builder.dart';

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

  if (sourceAssignment.shouldUseFunction()) {
    return _generateFunctionMapping(sourceAssignment, abstractMapper, targetField);
  } else if (sourceAssignment.shouldAssignList(targetField.type)) {
    return generateListAssignment(sourceAssignment, abstractMapper, targetField);
  } else {
    return generateNestedMapping(
      abstractMapper,
      targetField.type,
      sourceAssignment,
      _generateSourceFileAssignment(sourceAssignment)
    );
  }
}

Expression _generateSourceFileAssignment(SourceAssignment sourceAssignment) {
  final sourceField = sourceAssignment.field!;
  final sourceReference = refer(sourceAssignment.sourceName!);
  return sourceReference.property(sourceField.name);
}

Expression _generateFunctionMapping(
  SourceAssignment sourceAssignment,
  ClassElement abstractMapper,
  VariableElement targetField
) {

    final sourceFunction = sourceAssignment.function!;
    final references = sourceAssignment.params!
        .map((sourceParam) => refer(sourceParam.displayName));

    Expression expr = refer(sourceFunction.name);
    if (sourceFunction.isStatic &&
        sourceFunction.enclosingElement.name != null) {
      expr = refer(sourceFunction.enclosingElement.name!)
          .property(sourceFunction.name);
    }

    Expression sourceFieldAssignment = expr.call([...references], makeNamedArgumentForStaticFunction(sourceFunction));

    // The return of the function may be needed a nested mapping.
    return generateNestedMappingForFunctionMapping(
      sourceFunction,
      abstractMapper,
      targetField,
      sourceFieldAssignment);
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
