// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class DogMapperImpl extends DogMapper {
  @override
  Dog fromDogModel(DogModel model) {
    final dog = Dog(model.dogName, model.breed, model.dogAge);
    return dog;
  }
}
