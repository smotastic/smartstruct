import 'package:smartstruct/smartstruct.dart';
import 'package:smartstruct_example/function_mapping/function_utils.dart';
part 'function_mapping.mapper.g.dart';

// TARGET

class Dog {
  final String name;
  final String breed;
  final int age;

  Dog(this.name, this.breed, this.age);
}

// SOURCE

class DogModel {
  final String name;
  final int age;

  DogModel(this.name, this.age);
}

/// Mapper showcasing explicit fieldmapping in case fields do not match their respective fieldnames
@Mapper()
abstract class DogMapper {
  static String breedCustom(DogModel model) => 'customBreed';

  @Mapping(source: fullNameWithAge, target: 'name')
  @Mapping(source: FunctionUtils.mapAge, target: 'age')
  @Mapping(source: breedCustom, target: 'breed')
  Dog fromDogModel(DogModel model);
}

String fullNameWithAge(DogModel model) => model.name + '${model.age}';
