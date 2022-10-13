// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class DogMapperImpl extends DogMapper {
  DogMapperImpl() : super();

  @override
  Dog fromDogModel(
    DogModel model,
    int age,
  ) {
    final dog = Dog(
      model.dogName,
      model.breed,
      age,
    );
    return dog;
  }
}
