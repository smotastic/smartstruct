import 'package:smartstruct/smartstruct.dart';
part 'dog_mapping.mapper.g.dart';

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

  DogModel(
    this.dogName,
    this.breed,
  );
}

/// Mapper showcasing explicit fieldmapping in case fields do not match their respective fieldnames
@Mapper()
abstract class DogMapper {
  @Mapping(source: 'dogName', target: 'name')
  @Mapping(source: 'age', target: 'age', isStraight: true)
  Dog fromDogModel(DogModel model, int age);
}
