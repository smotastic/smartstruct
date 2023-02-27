// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class DogMapperImpl extends DogMapper {
  DogMapperImpl() : super();

  @override
  Dog fromDogModel(DogModel model) {
    final dog = Dog(
      fullNameWithAge(model),
      DogMapper.breedCustom(model),
      FunctionUtils.mapAge(model),
    );
    return dog;
  }
}
