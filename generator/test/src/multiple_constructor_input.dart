part of 'mapper_test_input.dart';

class MultiConTarget {
  String? text;
  num? number;

  MultiConTarget.single();
  MultiConTarget.multi(this.text, this.number);
}

class MultiConSource {
  final String text;
  final num number;

  MultiConSource(this.text, this.number);
}

@Mapper()
@ShouldGenerate(r'''
class MultiConMapperImpl extends MultiConMapper {
  MultiConMapperImpl() : super();

  @override
  MultiConTarget fromSource(MultiConSource source) {
    final multicontarget = MultiConTarget.multi(source.text, source.number);
    return multicontarget;
  }
}
''')
abstract class MultiConMapper {
  MultiConTarget fromSource(MultiConSource source);
}
