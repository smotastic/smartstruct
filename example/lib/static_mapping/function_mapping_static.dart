import 'package:smartstruct/smartstruct.dart';

part 'function_mapping_static.mapper.g.dart';

// TARGET

class Dog {
  final String name;
  final String breed;
  final int age;
  late AgeHolderTarget? model;

  Dog(this.name, this.breed, this.age);
}

// SOURCE

class DogModel {
  final String name;
  final int age;

  DogModel(this.name, this.age);
}

class AgeHolderSource {
  final int age;
  AgeHolderSource(this.age);
}

class AgeHolderTarget {
  late int age;
}

// This example uses static helper methods to map inner fields
@Mapper(useStaticMapping: false)
abstract class DogMapper {
  static String breedCustom(DogModel model) => 'customBreed';

  static AgeHolderSource? toAgeHolderSource(DogModel model) =>
      AgeHolderSource(model.age);

  static String fullNameWithAge(DogModel model) => model.name + '${model.age}';

  @Mapping(source: fullNameWithAge, target: 'name')
  @Mapping(source: breedCustom, target: 'breed')
  @Mapping(source: toAgeHolderSource, target: 'model')
  Dog fromDogModel(DogModel model);

  AgeHolderTarget fromAgeHolderSource(AgeHolderSource model);
}
