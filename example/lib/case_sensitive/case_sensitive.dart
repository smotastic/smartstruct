import 'package:smartstruct/smartstruct.dart';
part 'case_sensitive.mapper.g.dart';

class Source {
  final String userName;

  Source(this.userName);
}

class Target {
  final String username;

  Target({required this.username});
}

@Mapper(caseSensitiveFields: false)
abstract class ExampleMapper {
  Target fromSource(Source source);
}
