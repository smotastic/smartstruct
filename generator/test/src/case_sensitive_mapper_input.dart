part of 'mapper_test_input.dart';

class Source {
  final String username;

  Source(this.username);
}

class Target {
  final String userName;
  Target(this.userName);
}

class Duplicated {
  final String username;
  final String userNAME;

  Duplicated(this.username, this.userNAME);
}

@Mapper()
@ShouldGenerate(r'''
class CaseInsensitiveMapperImpl extends CaseInsensitiveMapper {
  CaseInsensitiveMapperImpl() : super();

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
  CaseSensitiveMapperImpl() : super();

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

@Mapper(caseSensitiveFields: true)
@ShouldGenerate(r'''
class CaseSensitiveDuplicateMapperImpl extends CaseSensitiveDuplicateMapper {
  CaseSensitiveDuplicateMapperImpl() : super();

  @override
  Duplicated fromSource(Duplicated source) {
    final duplicated = Duplicated(
      source.username,
      source.userNAME,
    );
    return duplicated;
  }
}
''')
abstract class CaseSensitiveDuplicateMapper {
  Duplicated fromSource(Duplicated source);
}
