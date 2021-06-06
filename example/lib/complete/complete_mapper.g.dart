// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class FooBarMapperImpl extends FooBarMapper {
  @override
  Bar fromFoo(Foo foo) {
    final bar = Bar(foo.someNumber, foo.someString, foo.someBool,
        foo.finalNamed, foo.nonFinalSetter, foo.nonFinalProperty);
    return bar;
  }

  @override
  Foo fromBar(Bar bar) {
    final foo = Foo(bar.someNumber, bar.someString, bar.someBool,
        finalNamed: bar.finalNamed);
    foo.nonFinalProperty = bar.nonFinalProperty;
    foo.nonFinalSetter = bar.nonFinalSetter;
    return foo;
  }
}
