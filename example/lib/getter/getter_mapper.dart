import 'package:smartstruct/smartstruct.dart';

part 'getter_mapper.mapper.g.dart';

class GetterTarget {
  final String name;
  final int age;

  int foo = 0;

  GetterTarget({
    required this.name,
    required this.age,
  });

  List<Object?> get props => [name, age];

  bool get sample => false;
}

class GetterSource {
  final String name;
  final int age;

  int foo = 1;

  GetterSource({
    required this.name,
    required this.age,
  });

  List<Object?> get props => [name, age];

  bool get sample => true;
}

@Mapper()
abstract class GetterMapper {
  GetterTarget fromModel(GetterSource source);
}
