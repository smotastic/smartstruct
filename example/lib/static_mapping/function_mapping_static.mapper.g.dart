// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_mapping_static.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class DogMapperImpl extends DogMapper {
  DogMapperImpl() : super();

  @override
  Dog fromDogModel(DogModel model) {
    final dog = Dog(DogMapper.fullNameWithAge(model),
        DogMapper.breedCustom(model), model.age);
    dog.model = () {
      final tmp = DogMapper.toAgeHolderSource(model);
      return tmp == null ? null : fromAgeHolderSource(tmp);
    }();
    return dog;
  }

  @override
  AgeHolderTarget fromAgeHolderSource(AgeHolderSource model) {
    final ageholdertarget = AgeHolderTarget();
    ageholdertarget.age = model.age;
    return ageholdertarget;
  }
}
