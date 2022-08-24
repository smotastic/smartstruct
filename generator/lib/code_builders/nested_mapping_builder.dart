// Sometimes we need to pass some variable to the static function just like "this pointer".
// We can use the named parameters to implement the goal.
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/models/source_assignment.dart';

import '../models/RefChain.dart';

Expression generateNestedMapping(
  ClassElement abstractMapper, 
  DartType targetType, 
  SourceAssignment sourceAssignment,
  Expression expression
) {

  // found a mapping method in the class which will map the source to target
  final nestedMapping = findMatchingMappingMethod(abstractMapper, targetType, sourceAssignment.field!.type);

  if (nestedMapping == null) {
    return expression;
  }

  return _generateNestedMapping(
    nestedMapping, 
    sourceAssignment.refChain!,
  );
}

Reference generateNestedMappingLambda(
  DartType inputType,
  MethodElement nestedMapping,
) {

  if(
    _isTypeNullable(inputType) && 
    !isNestedMappingSourceNullable(nestedMapping)
  ) {
    return refer('''
      (x) => x == null ? null : ${nestedMapping.name}(x)
    ''');
  }

  return refer('''
    (x) => ${nestedMapping.name}(x)
  ''');
}

bool isNestedMappingSourceNullable(MethodElement nestedMapping) {
  return _isTypeNullable(nestedMapping.parameters.first.type);
}

bool _isTypeNullable(DartType type) {
  return type.nullabilitySuffix == NullabilitySuffix.question;
}

Expression generateNestedMappingForFunctionMapping(
  ExecutableElement sourceFunction,
  ClassElement abstractMapper,
  VariableElement targetField,
  Expression sourceFieldAssignment,
) {
  final returnType = sourceFunction.returnType;
  final nestedMapping = findMatchingMappingMethod(
      abstractMapper, targetField.type, returnType);

  if(nestedMapping == null) {
    return sourceFieldAssignment;
  }


  if(
    _isTypeNullable(sourceFunction.returnType) &&
    !isNestedMappingSourceNullable(nestedMapping)
  ) {
    return generateSafeCall(sourceFieldAssignment, nestedMapping);
  } else {
    return refer(
      nestedMapping.name
    ).call([sourceFieldAssignment]);
  }
}

/// Finds a matching Mapping Method in [classElement]
/// which has the same return type as the given [targetReturnType] and same parametertype as the given [sourceParameterType]
Iterable<MethodElement> _findMatchingMappingMethods(ClassElement classElement,
    DartType targetReturnType, DartType sourceParameterType) {
  final matchingMappingMethods = classElement.methods.where((met) {
    // Sometimes the user is troubled by the nullability of these types.
    // So ingore the nullability of all the type for the nested mapping function is more easy to be matched.
    // The process of nullability is one duty for this library.

    if(met.parameters.isEmpty) {
        return false;
    }
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

MethodElement? findMatchingMappingMethod(ClassElement classElement,
    DartType targetReturnType, DartType sourceParameterType) {
  
  final methods = _findMatchingMappingMethods(classElement, targetReturnType, sourceParameterType);
  return methods.isEmpty ? null : methods.first;
}


generateSafeCall(
  Expression checkTarget,
  MethodElement nestedMapping,
) {

  String checkExpString = checkTarget.accept(
    DartEmitter()
  ).toString();
  final methodInvoke = refer(nestedMapping.name).call([refer("tmp")]).accept(DartEmitter()).toString();
  return refer('''
  (){
    final tmp = $checkExpString;
    return tmp == null ? null : $methodInvoke;
  }()
''');
}

Expression _generateNestedMapping(
  MethodElement nestedMapping, 
  RefChain inputRefChain,
) {
  if(isNestedMappingSourceNullable(nestedMapping)) {
    // The parameter can be null.
    return refer(nestedMapping.name)
        .call([refer(inputRefChain.refWithQuestion)]);
  } else {
    return generateSafeExpression(
      inputRefChain.isNullable,
      refer(inputRefChain.refWithQuestion), 
      refer(nestedMapping.name).call([refer(inputRefChain.ref)])
    );
  }
}

// needCheck =  true => sourceRef == null ? null : expression
// needCheck = false => sourceRef
Expression generateSafeExpression(
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

