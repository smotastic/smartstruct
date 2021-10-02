part of 'mapper_test_input.dart';

class InheritanceTarget {
  final String text;
  final num number;

  InheritanceTarget(this.text, this.number);
}

class SubSource {
  final String text;

  SubSource(this.text);
}

class InheritanceSource extends SubSource {
  final num number;

  InheritanceSource(String text, this.number) : super(text);
}

@Mapper()
@ShouldGenerate(r'''
class InheritanceMapperImpl extends InheritanceMapper {
  InheritanceMapperImpl() : super();

  @override
  InheritanceTarget fromSource(InheritanceSource source) {
    final inheritancetarget = InheritanceTarget(source.text, source.number);
    return inheritancetarget;
  }
}
''')
abstract class InheritanceMapper {
  InheritanceTarget fromSource(InheritanceSource source);
}
