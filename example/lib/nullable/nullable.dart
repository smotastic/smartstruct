import 'package:smartstruct/smartstruct.dart';

part 'nullable.mapper.g.dart';

class Foo {
  final String fooBar;
  final String fooBar2;

  Foo(this.fooBar, this.fooBar2);
}

class Bar {
  final String? fooBar;
  final String? fooBar2;

  Bar(this.fooBar, this.fooBar2);
}


/// Mapper showcasing mapping from optional to required field with defaultValue
@Mapper()
abstract class FooBarMapper {
  @Mapping(source: 'fooBar', target: 'fooBar', defaultValue: "''")
  Foo fromBar(Bar bar);
}
