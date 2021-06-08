import 'package:smartstruct/annotations.dart';
part 'field_mapping_mapper.g.dart';

class Dog {
  final String name;
  final String breed;
  final int age;

  Dog(this.name, this.breed, this.age);
}

class DogModel {
  final String dogName;
  final String breed;
  final int dogAge;

  DogModel(this.dogName, this.breed, this.dogAge);
}

@Mapper()
abstract class DogMapper {
  @Mapping(source: 'dogName', target: 'name')
  @Mapping(source: 'dogAge', target: 'age')
  Dog fromDogModel(DogModel model);
}
