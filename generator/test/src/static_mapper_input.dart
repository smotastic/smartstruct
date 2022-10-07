part of 'mapper_test_input.dart';

enum StaticEnumTarget {
  ONE,TWO,THREE
}

class StaticMappingTarget {
  final String text;
  final num number;
  final StaticEnumTarget foo;

  StaticMappingTarget(this.text, this.number, this.foo);
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
    StaticMappingMapper.mapEnum(source),
  );
  return staticmappingtarget;
}
''')
abstract class StaticMappingMapper {
  static String ignoredPrimitiveTypeMethod() => "ignore me"; // should not generate extra helper

  // these helpers should not be generated as they are either primitive, or are not explicitly declared to be generated via the StaticMapping Annotation
  static StaticEnumTarget mapEnum(StaticMappingSource source) => StaticEnumTarget.ONE;
  static List<StaticEnumTarget> mapEnumList(StaticMappingSource source) => [StaticEnumTarget.ONE, StaticEnumTarget.THREE];
  static Set<String> mapSomeSet(StaticMappingSource source) => {"1", "2"};

  // this helper should be generated as it is explicitly configured to do so via the StaticMapping Annotation
  @StaticMapping()
  @Mapping(source: mapEnum, target: 'foo')
  static StaticMappingTarget fromSourceStatic(StaticMappingSource source) => _$fromSourceStatic(source);

  StaticMappingTarget fromSourceNormal(StaticMappingSource source);
}

// just so the test compiles
StaticMappingTarget _$fromSourceStatic(StaticMappingSource source) => StaticMappingTarget("text", 1, StaticEnumTarget.THREE);
