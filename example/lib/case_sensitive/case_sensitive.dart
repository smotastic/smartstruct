import 'package:smartstruct/smartstruct.dart';
part 'case_sensitive.g.dart';

class SourceClass {
  final String userName;

  SourceClass(this.userName);
}

class TargetClass {
  final String username;

  TargetClass({required this.username});
}

@Mapper()
abstract class ExampleMapper {
  TargetClass call(SourceClass source);
}
