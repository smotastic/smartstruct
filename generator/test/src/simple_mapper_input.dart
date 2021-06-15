part of 'mapper_test_input.dart';

class SimpleTarget {
  final String text;
  final num number;

  SimpleTarget(this.text, this.number);
}

class SimpleSource {
  final String text;
  final num number;

  SimpleSource(this.text, this.number);
}

@Mapper()
@ShouldGenerate(r'''
class SimpleMappeImpl extends SimpleMapper {
  @override
  SimpleTarget fromSource(SimpleSource source) {
    final simpletarget = SimpleTarget(source.text, source.number);
    return simpletarget;
  }
}
''')
abstract class SimpleMapper {
  SimpleTarget fromSource(SimpleSource source);
}
