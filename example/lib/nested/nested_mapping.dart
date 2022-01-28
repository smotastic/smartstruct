import 'package:smartstruct/smartstruct.dart';

part 'nested_mapping.mapper.g.dart';

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
abstract class UserMapper {
  @Mapping(target: 'zipcode', source: 'response.address.zipcode')
  @Mapping(target: 'street', source: 'response.address.street.streetName')
  User fromResponse(UserResponse response);
}
