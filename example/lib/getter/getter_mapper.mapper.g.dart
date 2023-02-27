// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getter_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class GetterMapperImpl extends GetterMapper {
  GetterMapperImpl() : super();

  @override
  GetterTarget fromModel(GetterSource source) {
    final gettertarget = GetterTarget(
      name: source.name,
      age: source.age,
    );
    gettertarget.foo = source.foo;
    return gettertarget;
  }
}
