import 'package:smartstruct/annotations.dart';

part 'simple_mapper.g.dart';

class Foo {
  final String fooBar;

  Foo(this.fooBar);
}

class Bar {
  final String fooBar;

  Bar(this.fooBar);
}

@Mapper()
abstract class FooBarMapper {
  Bar fromFoo(Foo foo);
  Foo fromBar(Bar bar);
}
