part of 'mapper_test_input.dart';

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
@ShouldGenerate(r'''
class ExplicitGetterMapperImpl extends ExplicitGetterMapper {
  ExplicitGetterMapperImpl() : super();

  @override
  GetterTarget fromModel(GetterSource source) {
    final gettertarget = GetterTarget(
      name: source.name,
      age: source.age,
    );
    gettertarget.foo = source.foo;
    return gettertarget;
  }
}
''')
abstract class ExplicitGetterMapper {
  GetterTarget fromModel(GetterSource source);
}
