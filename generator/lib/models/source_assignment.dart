import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:smartstruct_generator/models/RefChain.dart';

class SourceAssignment {
  FieldElement? field;
  String? sourceName;
  //this attr is judge whether the parameter need to fill the target straightly
  bool isStraight = false;

  ExecutableElement? function;
  List<ParameterElement>? params;

  RefChain? refChain;

  //if you use the method to create the SourceAssignment, isStraight default will be true
  SourceAssignment.fromField(this.field, this.sourceName, {this.isStraight = true});
  SourceAssignment.fromFunction(this.function, this.params);
  SourceAssignment.fromRefChain(this.refChain) {
    sourceName = refChain!.removeLast().refWithQuestion;
    field = refChain?.elementList.last as FieldElement;
  }

  bool shouldAssignList(DartType targetFieldType) {
    // The source can be mapped to the target, if the source is mapable object and the target is listLike.
    return _isCoreListLike(targetFieldType) && _isMapable(field!.type);
  }

  bool _isCoreListLike(DartType type) {
    return type.isDartCoreList || type.isDartCoreSet || type.isDartCoreIterable;
  }

  bool _isMapable(DartType type) {
    if (_isCoreListLike(type)) {
      return true;
    }

    if (type is! InterfaceType) {
      return false;
    }
    return type.allSupertypes.any(_isCoreListLike);
  }

  String collectInvoke(DartType type) {
    if (type.isDartCoreList) {
      return "toList()";
    } else if (type.isDartCoreSet) {
      return "toSet()";
    }
    throw "Unkown type ${type.getDisplayString(withNullability: false)}";
  }

  bool needCollect(DartType targetType) {
    return !targetType.isDartCoreIterable;
  }

  bool shouldUseFunction() {
    return function != null;
  }
}
