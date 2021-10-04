part of 'mapper_test_input.dart';

abstract class SuperSource {
  final String superText;
  String get abstractGetterText;

  String get mappable {
    return 'mappable';
  }

  SuperSource(this.superText);
}

class InheritanceSource extends SuperSource {
  final num number;

  @override
  final String abstractGetterText;

  InheritanceSource(this.abstractGetterText, this.number, String superText)
      : super(superText);
}

class InheritanceTarget {
  final String abstractGetterText;
  final num number;
  final String superText;
  final String mappable;

  InheritanceTarget(
      this.abstractGetterText, this.number, this.superText, this.mappable);
}

@Mapper()
@ShouldGenerate(r'''
class InheritanceMapperImpl extends InheritanceMapper {
  InheritanceMapperImpl() : super();

  @override
  InheritanceTarget fromSource(InheritanceSource source) {
    final inheritancetarget = InheritanceTarget(source.abstractGetterText,
        source.number, source.superText, source.mappable);
    return inheritancetarget;
  }
}
''')
abstract class InheritanceMapper {
  InheritanceTarget fromSource(InheritanceSource source);
}
