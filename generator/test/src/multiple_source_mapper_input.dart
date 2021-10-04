part of 'mapper_test_input.dart';

class MultiSourceTarget {
  final String text;
  final num number;

  MultiSourceTarget(this.text, this.number);
}

class MultiSourceSource {
  final String text;

  MultiSourceSource(this.text);
}

class MultiSourceSourceSecond {
  final String number;

  MultiSourceSourceSecond(this.number);
}

@Mapper()
@ShouldGenerate(r'''
class MultipleSourceMapperImpl extends MultipleSourceMapper {
  MultipleSourceMapperImpl() : super();

  @override
  MultiSourceTarget fromSource(
      MultiSourceSource source, MultiSourceSourceSecond source2) {
    final multisourcetarget = MultiSourceTarget(source.text, source2.number);
    return multisourcetarget;
  }
}
''')
abstract class MultipleSourceMapper {
  MultiSourceTarget fromSource(
      MultiSourceSource source, MultiSourceSourceSecond source2);
}
