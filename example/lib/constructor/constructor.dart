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
  ConstructorMapper(String? optionalPositional, String requiredPositional,
      {required String requiredNamed});
  // ConstructorMapper.bar({String foo: 'empty'});

  Target fromSource(Source source);
}
