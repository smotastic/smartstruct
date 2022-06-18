import 'package:smartstruct/smartstruct.dart';
import 'package:smartstruct_example/function_mapping/function_utils.dart';
part 'function_mapping_more.mapper.g.dart';

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

/// Mapper showcasing explicit fieldmapping in case fields do not match their respective fieldnames
@Mapper()
abstract class DogMapper {
  static String breedCustom(DogModel model) => 'customBreed';

  @Mapping(source: fullNameWithAge, target: 'name')
//   @Mapping(source: FunctionUtils.mapAge, target: 'age')
  @Mapping(source: breedCustom, target: 'breed')
  @Mapping(source: toAgeHolderSource, target: 'model')
  Dog fromDogModel(DogModel model);

  AgeHolderTarget fromAgeHolderSource(AgeHolderSource model);
}

String fullNameWithAge(DogModel model) => model.name + '${model.age}';
AgeHolderSource? toAgeHolderSource(DogModel model) => AgeHolderSource(model.age);