// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class UserMapperImpl extends UserMapper {
  UserMapperImpl() : super();

  @override
  User fromResponse(UserResponse response) {
    final user = User(response.username, response.address.zipcode,
        response.address.street.streetName);
    return user;
  }
}
