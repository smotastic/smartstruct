import 'package:smartstruct/annotations.dart';

part 'complete_mapper.g.dart';

class Foo {
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

  Foo(this.someNumber, this.someString, this.someBool, {this.finalNamed = ''});
}

class Bar {
  final num someNumber;
  final String someString;
  final bool someBool;
  final String finalNamed;
  final num? nonFinalSetter;
  final String? nonFinalProperty;

  Bar(this.someNumber, this.someString, this.someBool, this.finalNamed,
      this.nonFinalSetter, this.nonFinalProperty);
}

@Mapper()
abstract class FooBarMapper {
  Bar fromFoo(Foo foo);
  Foo fromBar(Bar bar);
}
