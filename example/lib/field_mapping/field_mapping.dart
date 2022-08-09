import 'package:smartstruct/smartstruct.dart';

part 'field_mapping.mapper.g.dart';

enum DogType { happy, angry }

// TARGET

class Dog {
  final String name;
  final String breed;
  final int age;
  final DogType dogType;

  Dog(this.name, this.breed, this.age, this.dogType);
}

// SOURCE

class DogModel {
  final String dogName;
  final String breed;
  final int dogAge;
  final String dogType;

  DogModel(this.dogName, this.breed, this.dogAge, this.dogType);
}

/// Mapper showcasing explicit fieldmapping in case fields do not match their respective fieldnames
@Mapper()
abstract class DogMapper {
  static DogType _mapDogType(DogModel model) {
    if (model.dogType == 'angry') return DogType.angry;

    return DogType.happy;
  }

  @Mapping(source: 'dogName', target: 'name')
  @Mapping(source: 'dogAge', target: 'age')
  @Mapping(source: _mapDogType, target: 'dogType')
  Dog fromDogModel(DogModel model);
}
