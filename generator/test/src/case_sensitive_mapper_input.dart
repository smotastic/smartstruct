part of 'mapper_test_input.dart';

class Source {
  final String username;

  Source(this.username);
}

class Target {
  final String userName;
  Target(this.userName);
}

@Mapper()
@ShouldGenerate(r'''
class CaseInsensitiveMapperImpl extends CaseInsensitiveMapper {
  @override
  Target fromSource(Source source) {
    final target = Target(source.username);
    return target;
  }
}
''')
abstract class CaseInsensitiveMapper {
  Target fromSource(Source source);
}

@Mapper(caseSensitiveFields: true)
@ShouldGenerate(r'''
class CaseSensitiveMapperImpl extends CaseSensitiveMapper {
  @override
  Target fromSource(Source source) {
    final target = Target();
    return target;
  }
}
''')
abstract class CaseSensitiveMapper {
  Target fromSource(Source source);
}
