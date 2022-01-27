// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezed_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class FreezedMapperImpl extends FreezedMapper {
  FreezedMapperImpl() : super();

  @override
  FreezedTarget fromModel(FreezedSource model) {
    final freezedtarget = FreezedTarget(model.name, model.age);
    return freezedtarget;
  }
}

class FreezedNamedMapperImpl extends FreezedNamedMapper {
  FreezedNamedMapperImpl() : super();

  @override
  FreezedNamedTarget fromModel(FreezedNamedSource model) {
    final freezednamedtarget =
        FreezedNamedTarget(name: model.name, age: model.age);
    return freezednamedtarget;
  }
}
