// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class DogMapperImpl extends DogMapper {
  DogMapperImpl() : super();

  @override
  Dog fromDogModel(DogModel model) {
    final dog = Dog(
        model.dogName, model.breed, model.dogAge, DogMapper._mapDogType(model));
    return dog;
  }
}
