part of 'mapper_test_input.dart';

class NullablePropertiesTarget {
  final String text;
  final num number;

  NullablePropertiesTarget(this.text, this.number);
}

class NullablePropertiesSource {
  final String? text;
  final num? number;

  NullablePropertiesSource(this.text, this.number);
}

@Mapper()
@ShouldGenerate(r'''
class NullablePropertiesMapperImpl extends NullablePropertiesMapper {
  NullablePropertiesMapperImpl() : super();

  @override
  NullablePropertiesTarget fromSource(NullablePropertiesSource source) {
    assert(source.text != null, 'text cannot be blank');
    final nullablepropertiestarget =
        NullablePropertiesTarget(source.text!, source.number ?? 0);
    return nullablepropertiestarget;
  }
}
''')
abstract class NullablePropertiesMapper {
  @Mapping(source: 'number', target: 'number', defaultValue: '0')
  NullablePropertiesTarget fromSource(NullablePropertiesSource source);
}

