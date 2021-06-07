import 'package:injectable/injectable.dart';
import 'package:smartstruct/annotations.dart';

part 'setter_mapper.g.dart';

class Foo {
  late String _fooBar;

  String get fooBar => _fooBar;

  set fooBar(String fooBar) {
    _fooBar = fooBar;
  }
}

class Bar {
  final String fooBar;
  Bar(this.fooBar);
}

@Mapper(useInjection: true)
abstract class FooBarMapper {
  Bar fromFoo(Foo foo);
}
