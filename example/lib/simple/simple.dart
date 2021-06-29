import 'package:smartstruct/smartstruct.dart';

part 'simple.mapper.g.dart';

class Foo {
  final String fooBar;

  Foo(this.fooBar);
}

class Bar {
  final String fooBar;

  Bar(this.fooBar);
}

/// Mapper showcasing a simple mapping between two fields
@Mapper()
abstract class FooBarMapper {
  Bar? fromFoo(Foo? foo);
  Foo fromBar(Bar bar);
}
