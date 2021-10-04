import 'package:smartstruct/smartstruct.dart';

part 'inheritance.mapper.g.dart';

abstract class SuperFooSource {
  final String superFoo;
  String? _superProp;

  String? get superProp => _superProp;

  set superProp(String? superProp) {
    _superProp = superProp;
  }

  String get superText;

  String get mappable {
    return 'mappable';
  }

  SuperFooSource(this.superFoo);
}

class FooSource extends SuperFooSource {
  final String subFoo;
  @override
  final String superText;

  FooSource(this.subFoo, this.superText, String superFoo) : super(superFoo);
}

class BarTarget {
  final String subFoo;
  final String superFoo;
  final String mappable;
  final String? superProp;

  BarTarget(this.subFoo, this.superFoo, this.mappable, this.superProp);
}

@Mapper()
abstract class InheritanceMapper {
  BarTarget fromFoo(FooSource source);
}
