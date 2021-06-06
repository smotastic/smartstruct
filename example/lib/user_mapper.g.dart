// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class UserMapperImpl extends UserMapper {
  @override
  User fromModel(UserModel model) {
    final user =
        User(model.id, model.isActivated, model.unknown, name: model.name);
    user.lastName = model.lastName;
    return user;
  }

  @override
  UserModel fromEntity(User entity) {
    final usermodel =
        UserModel(entity.id, entity.name, entity.isActivated, entity.unknown);
    usermodel.lastName = entity.lastName;
    return usermodel;
  }
}

class UserModelMapperImpl extends UserModelMapper {
  @override
  UserModel from(User entity) {
    final usermodel =
        UserModel(entity.id, entity.name, entity.isActivated, entity.unknown);
    usermodel.lastName = entity.lastName;
    return usermodel;
  }
}
