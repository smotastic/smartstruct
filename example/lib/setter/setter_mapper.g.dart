// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setter_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

@LazySingleton(as: FooBarMapper)
class FooBarMapperImpl extends FooBarMapper {
  @override
  Bar fromFoo(Foo foo) {
    final bar = Bar(foo.fooBar);
    return bar;
  }
}
