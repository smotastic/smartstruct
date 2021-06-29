import 'package:smartstruct/smartstruct.dart';
part 'field_mapping.mapper.g.dart';

// TARGET

class Dog {
  final String name;
  final String breed;
  final int age;

  Dog(this.name, this.breed, this.age);
}

// SOURCE

class DogModel {
  final String dogName;
  final String breed;
  final int dogAge;

  DogModel(this.dogName, this.breed, this.dogAge);
}

/// Mapper showcasing explicit fieldmapping in case fields do not match their respective fieldnames
@Mapper()
abstract class DogMapper {
  @Mapping(source: 'dogName', target: 'name')
  @Mapping(source: 'dogAge', target: 'age')
  Dog fromDogModel(DogModel model);
}
