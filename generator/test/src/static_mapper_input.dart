part of 'mapper_test_input.dart';

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
@ShouldGenerate(r'''
class StaticMappingMapperImpl extends StaticMappingMapper {
  StaticMappingMapperImpl() : super();

  @override
  StaticMappingTarget fromSourceNormal(StaticMappingSource source) {
    final staticmappingtarget = StaticMappingTarget(
      source.text,
      source.number,
    );
    return staticmappingtarget;
  }
}

StaticMappingTarget _$fromSourceStatic(StaticMappingSource source) {
  final staticmappingtarget = StaticMappingTarget(
    source.text,
    source.number,
  );
  return staticmappingtarget;
}
''')
abstract class StaticMappingMapper {
  static String someRandomMethodWhichShouldBeIgnored() => "ignore me";
  StaticMappingTarget fromSourceNormal(StaticMappingSource source);
  static StaticMappingTarget fromSourceStatic(StaticMappingSource source) => _$fromSourceStatic(source);
}

// just so the test compiles
StaticMappingTarget _$fromSourceStatic(StaticMappingSource source) => StaticMappingTarget("text", 1);
