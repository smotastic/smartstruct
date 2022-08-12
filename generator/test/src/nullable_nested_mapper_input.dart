part of 'mapper_test_input.dart';

class NullableNestedSource {

  final NestedSubSource? nested;

  NullableNestedSource(this.nested);
}


class NullableNestedTarget {

  final NestedSubTarget? nested;

  NullableNestedTarget(this.nested);
}

@Mapper()
@ShouldGenerate('''
class NullableNestedMapperImpl extends NullableNestedMapper {
  NullableNestedMapperImpl() : super();

  @override
  NullableNestedTarget fromSource(NestedSource source) {
    final nullablenestedtarget =
        NullableNestedTarget(fromSubSource(source.nested));
    return nullablenestedtarget;
  }

  @override
  NullableNestedTarget fromNullableSource(NullableNestedSource source) {
    final nullablenestedtarget = NullableNestedTarget(
        source.nested == null ? null : fromSubSource(source.nested!));
    return nullablenestedtarget;
  }

  @override
  NestedSubTarget fromSubSource(NestedSubSource source) {
    final nestedsubtarget = NestedSubTarget(source.text);
    return nestedsubtarget;
  }
}
''')
abstract class NullableNestedMapper {
  NullableNestedTarget fromSource(NestedSource source);
  NullableNestedTarget fromNullableSource(NullableNestedSource source);

  NestedSubTarget fromSubSource(NestedSubSource source);
}
