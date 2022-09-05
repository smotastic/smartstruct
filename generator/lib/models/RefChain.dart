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
		// Ingore the nullability of the first element
    final _elementList = elementList.sublist(1);
    isNullable = _elementList.any((x) => checkNullable(x));
    makeRef();
  }

  makeRef() {
    // the first element is not nullability.
    if(elementList.isEmpty) {
      ref = '';
      refWithQuestion = '';
      return;
    }

    final first = elementList[0];

    if(elementList.length == 1) {
      refWithQuestion = first.name;
      ref = first.name;
    } else {
    // _elementList.length >= 1, elementList.length >= 2
    ref = [
			first.name,
			..._makeVarChainList(elementList.sublist(1),"!")
    ].join('.');
			refWithQuestion = [
					first.name,
					..._makeVarChainList(elementList.sublist(1, elementList.length - 1), "?"),
					elementList.last.name
			].join('.');
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
    return elementList.map((e) => _makeVarChainName(e, nullPrefix));
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