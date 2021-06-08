import 'package:injectable/injectable.dart';
import 'package:smartstruct/annotations.dart';

part 'complete_mapper.g.dart';

class FooInput {
  final num number;
  final String text;
  final bool truthy;
  final String named;
  final String namedTwo;
  String property;
  String propertyTwo;
  num? setterNumber;
  String? setterText;
  FooInput(this.number, this.text, this.truthy, this.named, this.setterNumber,
      this.property, this.propertyTwo, this.namedTwo);
}

class BarOutput {
  final num numberDiff;
  final String text;
  final bool truthy;
  String named;
  String namedTwoDiff;
  String? property;
  String? propertyTwoDiff;
  num? _setterNumber;
  String? _setterTextDiff;

  String? get setterTextDiff => _setterTextDiff;

  set setterTextDiff(String? setterTextDiff) {
    _setterTextDiff = setterTextDiff;
  }

  num? get setterNumber => _setterNumber;

  set setterNumber(num? setterNumber) {
    _setterNumber = setterNumber;
  }

  BarOutput(this.numberDiff, this.text, this.truthy,
      {required this.named, required this.namedTwoDiff});
}

@Mapper(useInjection: true)
abstract class ExampleMapper {
  // static ExampleMapper get INSTANCE => ExampleMapperImpl();
  @Mapping(source: 'number', target: 'numberDiff')
  @Mapping(source: 'namedTwo', target: 'namedTwoDiff')
  @Mapping(source: 'setterText', target: 'setterTextDiff')
  @Mapping(source: 'propertyTwo', target: 'propertyTwoDiff')
  BarOutput fromFoo(FooInput input);
}
