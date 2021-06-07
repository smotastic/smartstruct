import 'package:injectable/injectable.dart';
import 'package:smartstruct/annotations.dart';

part 'complete_mapper.g.dart';

class FooInput {
  final num someNumber;
  final String someString;
  final bool someBool;
  final String finalNamed;
  final num? nonFinalSetter;
  final String? nonFinalProperty;
  FooInput(this.someNumber, this.someString, this.someBool, this.finalNamed,
      this.nonFinalSetter, this.nonFinalProperty);
}

class BarOutput {
  final num someNumber;
  final String someString;
  final bool someBool;
  String finalNamed;
  num? _nonFinalSetter;
  String? nonFinalProperty;

  num? get nonFinalSetter => _nonFinalSetter;

  set nonFinalSetter(num? nonFinalSetter) {
    _nonFinalSetter = nonFinalSetter;
  }

  BarOutput(this.someNumber, this.someString, this.someBool,
      {this.finalNamed = ''});
}

@Mapper(useInjection: true)
abstract class ExampleMapper {
  static ExampleMapper get INSTANCE => ExampleMapperImpl();
  BarOutput fromFoo(FooInput input);
}
