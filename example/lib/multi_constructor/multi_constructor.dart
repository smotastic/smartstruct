import 'package:smartstruct/smartstruct.dart';
part 'multi_constructor.mapper.g.dart';

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
abstract class MultiConMapper {
  MultiConTarget fromSource(MultiConSource source);
}
