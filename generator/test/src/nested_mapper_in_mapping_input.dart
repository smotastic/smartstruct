part of 'mapper_test_input.dart';

class User {
  final String username;
  final String zipcode;
  final String street;

  User(this.username, this.zipcode, this.street);
}

class UserResponse {
  final String username;
  final AddressResponse address;

  UserResponse(this.username, this.address);
}

class AddressResponse {
  final String zipcode;
  final StreetResponse street;

  AddressResponse(this.zipcode, this.street);
}

class StreetResponse {
  final num streetNumber;
  final String streetName;

  StreetResponse(this.streetNumber, this.streetName);
}

@Mapper()
@ShouldGenerate(r'''
class NestedMappingMapperImpl extends NestedMappingMapper {
  NestedMappingMapperImpl() : super();

  @override
  User fromResponse(UserResponse response) {
    final user = User(response.username, response.address.zipcode,
        response.address.street.streetName);
    return user;
  }
}
''')
@Mapper()
abstract class NestedMappingMapper {
  @Mapping(target: 'zipcode', source: 'response.address.zipcode')
  @Mapping(target: 'street', source: 'response.address.street.streetName')
  User fromResponse(UserResponse response);
}
