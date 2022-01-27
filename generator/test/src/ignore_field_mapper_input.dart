part of 'mapper_test_input.dart';

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
@ShouldGenerate(r'''
class IgnoreMapperImpl extends IgnoreMapper {
  IgnoreMapperImpl() : super();

  @override
  IgnoreTarget fromIgnore(IgnoreSource source) {
    final ignoretarget = IgnoreTarget(source.doNotIgnoreMe);
    return ignoretarget;
  }
}
''')
abstract class IgnoreMapper {
  @Mapping(target: 'ignoreMe', ignore: true)
  IgnoreTarget fromIgnore(IgnoreSource source);
}
