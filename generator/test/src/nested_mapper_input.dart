part of 'mapper_test_input.dart';

class NestedSource {
  final NestedSubSource nested;

  NestedSource(this.nested);
}

class NestedSubSource {
  final String text;

  NestedSubSource(this.text);
}

class NestedTarget {
  final NestedSubTarget nested;

  NestedTarget(this.nested);
}

class NestedSubTarget {
  final String text;

  NestedSubTarget(this.text);
}

@Mapper()
@ShouldGenerate(r'''
class NestedMapperImpl extends NestedMapper {
  NestedMapperImpl() : super();

  @override
  NestedTarget fromSource(NestedSource source) {
    final nestedtarget = NestedTarget(fromSubSource(source.nested));
    return nestedtarget;
  }

  @override
  NestedSubTarget fromSubSource(NestedSubSource source) {
    final nestedsubtarget = NestedSubTarget(source.text);
    return nestedsubtarget;
  }
}
''')
abstract class NestedMapper {
  NestedTarget fromSource(NestedSource source);
  NestedSubTarget fromSubSource(NestedSubSource source);
}
