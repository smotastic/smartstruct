part of 'mapper_test_input.dart';

class FunctionFieldSource {
  final String fieldTextSource;

  FunctionFieldSource(this.fieldTextSource);
}

class FunctionFieldTarget {
  final String fieldTextTarget;
  final num unmappedNum;
  final String unmappedText;

  FunctionFieldTarget(
      this.fieldTextTarget, this.unmappedNum, this.unmappedText);
}

@Mapper()
@ShouldGenerate(r'''
class FunctionFieldMapperImpl extends FunctionFieldMapper {
  FunctionFieldMapperImpl() : super();

  @override
  FunctionFieldTarget fromSource(FunctionFieldSource source) {
    final functionfieldtarget = FunctionFieldTarget(
      source.fieldTextSource,
      someNum(source),
      FunctionFieldMapper.someText(source),
    );
    return functionfieldtarget;
  }
}
''')
abstract class FunctionFieldMapper {
  static String someText(FunctionFieldSource source) => 'some text';
  @Mapping(source: 'fieldTextSource', target: 'fieldTextTarget')
  @Mapping(source: someNum, target: 'unmappedNum')
  @Mapping(source: someText, target: 'unmappedText')
  FunctionFieldTarget fromSource(FunctionFieldSource source);
}

num someNum(FunctionFieldSource source) => 2;
