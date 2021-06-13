part of 'mapper_test_input.dart';

class Target {
  final String text;
  final num number;

  Target(this.text, this.number);
}

class Source {
  final String text;
  final num number;

  Source(this.text, this.number);
}

@Mapper()
@ShouldGenerate(r'''
class SimpleMapperImpl extends SimpleMapper {
  @override
  Target fromSource(Source source) {
    final target = Target(source.text, source.number);
    return target;
  }
}
''')
abstract class SimpleMapper {
  Target fromSource(Source source);
}
