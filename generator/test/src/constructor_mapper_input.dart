part of 'mapper_test_input.dart';

@Mapper()
@ShouldGenerate(r'''
class ConstructorMapperImpl extends ConstructorMapper {
  ConstructorMapperImpl(
    String? optionalPos,
    String requiredPos, {
    required String requiredNamed,
    String? optionalNamed,
  }) : super(
          optionalPos,
          requiredPos,
          requiredNamed: requiredNamed,
          optionalNamed: optionalNamed,
        );

  ConstructorMapperImpl.foo(String text) : super.foo(text);
}
''')
abstract class ConstructorMapper {
  ConstructorMapper(String? optionalPos, String requiredPos,
      {required String requiredNamed, String? optionalNamed});
  ConstructorMapper.foo(String text);
}
