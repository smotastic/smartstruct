import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

// We can know lots of things from RefChain. Just like the generic type value or nullability of every field in the chain.
class RefChain {
  final List<VariableElement> elementList;
  late final bool isNullable;
  late final String ref;
  late final String refWithQuestion;

  factory RefChain.byPropNames(VariableElement element, Iterable<String> names) {
    final properyList = _toPropertyList(element, names);
    return RefChain([element, ...properyList]);
  }

  RefChain(this.elementList) {
    isNullable = elementList.any((x) => checkNullable(x));

    if(elementList.isEmpty) {
      ref = '';
      refWithQuestion = '';
    } else if(elementList.length == 1) {
      refWithQuestion = elementList[0].name;
      ref = elementList[0].name;
    } else {
      refWithQuestion = [
        _makeVarChainList(elementList.sublist(0, elementList.length - 1), "?"),
        elementList.last.name
      ].join(".");
      ref = _makeVarChainList(elementList,"!");
    }
  }

  _makeVarChainName(VariableElement element, String nullPrefix) {
    if(checkNullable(element)) {
      return "${element.name}$nullPrefix";
    } else {
      return element.name;
    }
  }

  _makeVarChainList(List<VariableElement> elementList, String nullPrefix) {
    return elementList.map((e) => _makeVarChainName(e, nullPrefix)).join('.');
  }

  checkNullable(VariableElement element) {
    return element.type.nullabilitySuffix == NullabilitySuffix.question;
  }

  from(VariableElement element) {
    return RefChain([element, ...elementList]);
  }

  removeLast() {
    return RefChain(elementList.sublist(0, elementList.length - 1));
  }
}


// Create the property list corresponding to the nameList. 
List<PropertyInducingElement> _toPropertyList(VariableElement element, Iterable<String> nameList) {
  final findTargetName = nameList.first;
  final propList = getAllReadProperty(element);
  
  final potentielFinds = propList.where((x) => x.getDisplayString(withNullability: false).endsWith(findTargetName));
  if(potentielFinds.isEmpty) {
    throw "Property is not found! $findTargetName";
  }

  final targetProp = potentielFinds.first;
  if(nameList.length == 1) {
    return [targetProp];
  }

  bool shouldContinue = targetProp.type is InterfaceType;
  if(shouldContinue) {
    return [targetProp, ..._toPropertyList(targetProp, nameList.skip(1))];
  } else {
    throw "";
  }
}

List<PropertyInducingElement> getAllReadProperty(VariableElement field) {
  final type = field.type;
  if(type is! InterfaceType) {
    return [];
  }

  return [...type.accessors, ...type.allSupertypes.expand((e) => e.accessors)]
    .where((e) => e.isGetter)
    .map((e) => e.variable)
    .toList();
}