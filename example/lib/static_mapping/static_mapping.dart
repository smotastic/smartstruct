import 'package:smartstruct/smartstruct.dart';

part 'static_mapping.mapper.g.dart';

class StaticMappingTarget {
  final String text;
  final num number;

  StaticMappingTarget(this.text, this.number);
}

class StaticMappingSource {
  final String text;
  final num number;

  StaticMappingSource(this.text, this.number);
}

@Mapper()
abstract class StaticMappingMapper {
  StaticMappingTarget fromSourceNormal(StaticMappingSource source);

  static StaticMappingTarget fromSourceStatic(StaticMappingSource source) =>
      _$fromSourceStatic(source);
}
