import 'package:analyzer/dart/element/element.dart';
import 'package:smartstruct_generator/models/RefChain.dart';

class SourceAssignment {
  FieldElement? field;
  String? sourceName;

  ExecutableElement? function;
  List<ParameterElement>? params;

  RefChain? refChain;

  SourceAssignment.fromField(this.field, this.sourceName);
  SourceAssignment.fromFunction(this.function, this.params);
  SourceAssignment.fromRefChain(this.refChain) {
    sourceName = refChain!.removeLast().refWithQuestion;
    field = refChain?.elementList.last as FieldElement;
  }

  bool shouldAssignList() {
    return field != null &&
        (field!.type.isDartCoreList || field!.type.isDartCoreIterable);
  }

  bool shouldUseFunction() {
    return function != null;
  }
}
