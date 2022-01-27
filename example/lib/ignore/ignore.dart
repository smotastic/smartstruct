import 'package:smartstruct/smartstruct.dart';
part 'ignore.mapper.g.dart';

class IgnoreSource {
  final String ignoreMe;
  final String doNotIgnoreMe;

  IgnoreSource(this.ignoreMe, this.doNotIgnoreMe);
}

class IgnoreTarget {
  String? ignoreMe;
  final String doNotIgnoreMe;

  IgnoreTarget(this.doNotIgnoreMe);
}

@Mapper()
abstract class IgnoreMapper {
  @Mapping(target: 'ignoreMe', ignore: true)
  IgnoreTarget fromIgnore(IgnoreSource source);
}
