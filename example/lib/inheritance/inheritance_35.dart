// For issue https://github.com/smotastic/smartstruct/issues/35

import 'package:smartstruct/smartstruct.dart';

part 'inheritance_35.mapper.g.dart';

abstract class DataContract {
  String get id;
}

class MyContract implements DataContract {
  MyContract(this.id);

  @override
  final String id;
}

class MyEntity {
  MyEntity(this.id);

  final String id;
}

@Mapper()
abstract class DataMapper {
  MyContract fromTarget(MyEntity entity);
}
