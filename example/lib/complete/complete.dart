import 'package:injectable/injectable.dart';
import 'package:smartstruct/smartstruct.dart';

part 'complete.g.dart';

class FooSource {
  final num number;
  final String text;
  final bool truthy;
  final String named;
  final String namedTwo;
  String property;
  String propertyTwo;
  num? setterNumber;
  String? setterText;
  late FooNestedSource nested;
  final List<FooNestedSource> list;
  FooSource(this.number, this.text, this.truthy, this.named, this.setterNumber,
      this.property, this.propertyTwo, this.namedTwo, this.list);
}

class FooNestedSource {
  late String text;
  final num number;

  FooNestedSource(this.number);
}

class BarTarget {
  final num numberDiff;
  final String text;
  final bool truthy;
  String named;
  String namedTwoDiff;
  String? property;
  String? propertyTwoDiff;
  num? _setterNumber;
  String? _setterTextDiff;
  late BarNestedTarget nested;
  final List<BarNestedTarget> list;

  String? get setterTextDiff => _setterTextDiff;

  set setterTextDiff(String? setterTextDiff) {
    _setterTextDiff = setterTextDiff;
  }

  num? get setterNumber => _setterNumber;

  set setterNumber(num? setterNumber) {
    _setterNumber = setterNumber;
  }

  BarTarget(this.numberDiff, this.text, this.truthy,
      {required this.named, required this.namedTwoDiff, required this.list});
}

class BarNestedTarget {
  final String text;
  final num number;

  BarNestedTarget(this.text, this.number);
}

/// Mapper showcasing every feature,
/// such as explicit fieldmapping, injection and mapping nested classes
@Mapper(useInjection: true)
abstract class ExampleMapper {
  static ExampleMapper get instance => ExampleMapperImpl();
  @Mapping(source: 'number', target: 'numberDiff')
  @Mapping(source: 'namedTwo', target: 'namedTwoDiff')
  @Mapping(source: 'setterText', target: 'setterTextDiff')
  @Mapping(source: 'propertyTwo', target: 'propertyTwoDiff')
  BarTarget fromFoo(FooSource source);

  BarNestedTarget fromFooSub(FooNestedSource source);
}
