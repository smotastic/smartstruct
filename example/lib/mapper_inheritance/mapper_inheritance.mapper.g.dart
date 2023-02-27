// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapper_inheritance.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class UserLoginContractFromEntityMapperImpl
    extends UserLoginContractFromEntityMapper {
  UserLoginContractFromEntityMapperImpl() : super();

  @override
  UserLoginContract? fromEntity(UserLoginEntity? entity) {
    if (entity == null) {
      return null;
    }
    ;
    final userlogincontract = UserLoginContract(
      entity.age,
      entity.id,
    );
    return userlogincontract;
  }
}

class UserLoginContractFromEntityMapper2Impl
    extends UserLoginContractFromEntityMapper2 {
  UserLoginContractFromEntityMapper2Impl() : super();

  @override
  UserLoginContract2? fromEntity(UserLoginEntity? entity) {
    if (entity == null) {
      return null;
    }
    ;
    final userlogincontract2 = UserLoginContract2(
      entity.age,
      entity.id,
    );
    return userlogincontract2;
  }
}
