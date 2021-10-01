import 'package:smartstruct/smartstruct.dart';

part 'inheritance.mapper.g.dart';

class SuperFooSource {
  final String superFoo;

  SuperFooSource(this.superFoo);
}

class FooSource extends SuperFooSource {
  final String subFoo;

  FooSource(this.subFoo, String superFoo) : super(superFoo);
}

class BarTarget {
  final String subFoo;
  final String superFoo;

  BarTarget(this.subFoo, this.superFoo);
}

/// Mapper showcasing a simple mapping between two fields
@Mapper()
abstract class InheritanceMapper {
  BarTarget fromFoo(FooSource source);
}
