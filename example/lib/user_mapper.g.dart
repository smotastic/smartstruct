// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class UserMapperImpl extends UserMapper {
  @override
  User fromModel(UserModel model) {
    return User(model.id, model.isActivated, null, name: model.name);
  }

  @override
  UserModel fromEntity(User entity) {
    return UserModel(entity.id, entity.name, entity.isActivated);
  }
}

class UserModelMapperImpl extends UserModelMapper {
  @override
  UserModel from(User entity) {
    return UserModel(entity.id, entity.name, entity.isActivated);
  }
}
