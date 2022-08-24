
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/models/source_assignment.dart';
import 'package:source_gen/source_gen.dart';

import 'nested_mapping_builder.dart';

generateListAssignment(SourceAssignment sourceAssignment,
    ClassElement abstractMapper, VariableElement targetField
) {
  final sourceField = sourceAssignment.field!;
  final sourceReference = refer(sourceAssignment.sourceName!);

  final sourceItemType = _getGenericTypeOfList(sourceField.type);
  final targetItemType = _getGenericTypeOfList(targetField.type);
  final nestedMapping = findMatchingMappingMethod(
      abstractMapper, targetItemType, sourceItemType);

  final needTargetFilter = _isTargetNotNullFilterNeeded(sourceItemType, targetItemType, nestedMapping);

  // mapping expression, default is just the identity,
  // for example for primitive types or objects that do not have their own mapping method
  final expr = nestedMapping == null ?
    refer('(e)=>e') :
    generateNestedMappingLambda(sourceItemType, nestedMapping);
  Expression sourceFieldAssignment =
    sourceReference.property(sourceField.name)
    .property('map')
    .call([expr]);

  if(needTargetFilter) {
    sourceFieldAssignment = sourceFieldAssignment
      .property("where")
      .call([refer("(x) => x != null")]);

    sourceFieldAssignment = _generateCollectCode(sourceAssignment, targetField.type, sourceFieldAssignment);
    sourceFieldAssignment = sourceFieldAssignment
      .asA(refer(targetField.type.getDisplayString(withNullability: true)));
  } else {
    sourceFieldAssignment = _generateCollectCode(sourceAssignment, targetField.type, sourceFieldAssignment);
  }

  return sourceFieldAssignment;
}

DartType _getGenericTypeOfList(DartType type) {
  if(type is! ParameterizedType) {
    throw InvalidGenerationSourceError(
      "The type ${type.getDisplayString(withNullability: false)} is not a ListLike type!"
    );
  }
  return type.typeArguments.first;
}

bool _isTargetNotNullFilterNeeded(
  DartType sourceItemType,
  DartType targetItemType,
  MethodElement? nestedMapping,
) {
  if(_isTypeNullable(targetItemType)) {
    // So the filter is not needed
    return false;
  }

  if(nestedMapping != null) {
    return
      _isTypeNullable(sourceItemType) &&
      (
        _isTypeNullable(nestedMapping.returnType) ||
        // When the source is null, the nested mapping will be skipped and the value null will be returned directly.
        // So the NotNullFilter is Needed.
        !isNestedMappingSourceNullable(nestedMapping)
      );
  }

  return _isTypeNullable(sourceItemType);
}

bool _isTypeNullable(DartType type) {
  return type.nullabilitySuffix == NullabilitySuffix.question;
}

Expression _generateCollectCode(SourceAssignment sourceAssignment, DartType targetType, Expression expression) 
=> sourceAssignment.needCollect(targetType) ?
  expression.property(sourceAssignment.collectInvoke(targetType)) :
  expression;