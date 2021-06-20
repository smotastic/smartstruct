part of 'mapper_test_input.dart';

class ExplicitFieldSource {
  final String fieldTextSource;
  final num fieldNumSource;

  ExplicitFieldSource(this.fieldTextSource, this.fieldNumSource);
}

class ExplicitFieldTarget {
  final String fieldTextTarget;
  final num fieldNumTarget;

  ExplicitFieldTarget(this.fieldTextTarget, this.fieldNumTarget);
}

@Mapper()
@ShouldGenerate(r'''
class ExplicitFeldMapperImpl extends ExplicitFieldMapper {
  @override
  ExplicitFieldTarget fromSource(ExplicitFieldSource source) {
    final explicitfieldtarget =
        ExplicitFieldTarget(source.fieldTextSource, source.fieldNumSource);
    return explicitfieldtarget;
  }
}
''')
abstract class ExplicitFieldMapper {
  @Mapping(source: 'fieldTextSource', target: 'fieldTextTarget')
  @Mapping(source: 'fieldNumSource', target: 'fieldNumTarget')
  ExplicitFieldTarget fromSource(ExplicitFieldSource source);
}
