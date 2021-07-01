import 'package:smartstruct/smartstruct.dart';

part 'constructor.mapper.g.dart';

class Source {
  final String text;

  Source(this.text);
}

class Target {
  final String text;

  Target(this.text);
}

@Mapper()
abstract class ConstructorMapper {
  ConstructorMapper(String? optionalPos, String requiredPos,
      {required String requiredNamed, String? optionalNamed});
  ConstructorMapper.foo(String text);

  Target fromSource(Source source);
}
