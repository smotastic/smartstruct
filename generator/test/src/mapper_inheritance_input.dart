part of 'mapper_test_input.dart';
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


class UserLoginEntity extends DomainEntity{
  int age;

  UserLoginEntity(this.age, int id) : super(id);
}

@Mapper()
@ShouldGenerate(r'''
class MapperInheritanceMapperImpl extends MapperInheritanceMapper {
  MapperInheritanceMapperImpl() : super();

  @override
  UserLoginContract? fromEntity(UserLoginEntity? entity) {
    if (entity == null) {
      return null;
    }
    ;
    final userlogincontract = UserLoginContract(entity.age, entity.id);
    return userlogincontract;
  }
}
''')
abstract class MapperInheritanceMapper extends ContractFromEntityMapper<UserLoginContract, UserLoginEntity> {
}