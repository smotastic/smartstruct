// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inheritance.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class InheritanceMapperImpl extends InheritanceMapper {
  InheritanceMapperImpl() : super();

  @override
  BarTarget fromFoo(FooSource source) {
    final bartarget = BarTarget(source.subFoo, source.superFoo);
    return bartarget;
  }
}
