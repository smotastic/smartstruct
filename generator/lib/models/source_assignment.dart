import 'package:analyzer/dart/element/element.dart';

class SourceAssignment {
  FieldElement? field;
  String? sourceName;

  ExecutableElement? function;
  List<ParameterElement>? params;

  SourceAssignment.fromField(this.field, this.sourceName);
  SourceAssignment.fromFunction(this.function, this.params);

  bool shouldAssignList() {
    return field != null &&
        (field!.type.isDartCoreList || field!.type.isDartCoreIterable);
  }

  bool shouldUseFunction() {
    return function != null;
  }
}
