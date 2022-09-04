import 'package:smartstruct/smartstruct.dart';
part '../gen/example/example.mapper.g.dart';

class Source {
  final String userName;

  Source(this.userName);
}

class Target {
  final String username;

  Target({required this.username});
}

@Mapper()
abstract class ExampleMapper {
  Target fromSource(Source source);
}
