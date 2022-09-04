import 'package:smartstruct/smartstruct.dart';

part 'mapper_inheritance.mapper.g.dart';

class DataContract {

    int id;

    DataContract(this.id);
}

class DomainEntity {
    int id;

    DomainEntity(this.id);

}

abstract class ContractFromEntityMapper<C extends DataContract, E extends DomainEntity> {
  C? fromEntity(E? entity);
}

class UserLoginContract extends DataContract{
  int age;

  UserLoginContract(this.age, int id) : super(id);
}

class UserLoginContract2 extends UserLoginContract{

  UserLoginContract2(int age, int id) : super(age, id);
}

class UserLoginEntity extends DomainEntity{
  int age;

  UserLoginEntity(this.age, int id) : super(id);
}

@Mapper()
abstract class UserLoginContractFromEntityMapper extends ContractFromEntityMapper<UserLoginContract, UserLoginEntity> {
}

@Mapper()
abstract class UserLoginContractFromEntityMapper2 extends ContractFromEntityMapper<UserLoginContract, UserLoginEntity> {
  @override
  UserLoginContract2? fromEntity(UserLoginEntity? entity);
}