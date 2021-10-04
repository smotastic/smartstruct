import 'package:analyzer/dart/element/element.dart';

class SourceAssignment {
  ClassElement? sourceClass;
  FieldElement? field;
  ParameterElement? param;

  ExecutableElement? function;
  List<ParameterElement>? params;

  SourceAssignment.fromField(this.sourceClass, this.field, this.param);
  SourceAssignment.fromFunction(this.function, this.params);

  bool shouldAssignList() {
    return field != null &&
        (field!.type.isDartCoreList || field!.type.isDartCoreIterable);
  }

  bool shouldUseFunction() {
    return function != null;
  }
}
