// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class FooBarMapperImpl extends FooBarMapper {
  FooBarMapperImpl() : super();

  @override
  Bar? fromFoo(Foo? foo) {
    if (foo == null) {
      return null;
    }
    ;
    final bar = Bar(foo.fooBar);
    return bar;
  }

  @override
  Foo fromBar(Bar bar) {
    final foo = Foo(bar.fooBar);
    return foo;
  }
}
