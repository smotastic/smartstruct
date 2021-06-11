// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

@LazySingleton(as: ExampleMapper)
class ExampleMapperImpl extends ExampleMapper {
  @override
  BarTarget fromFoo(FooSource source) {
    final baroutput = BarTarget(source.number, source.text, source.truthy,
        named: source.named, namedTwoDiff: source.namedTwo);
    baroutput.property = source.property;
    baroutput.propertyTwoDiff = source.propertyTwo;
    baroutput.nested = fromFooSub(source.nested);
    baroutput.setterTextDiff = source.setterText;
    baroutput.setterNumber = source.setterNumber;
    return baroutput;
  }

  @override
  BarNestedTarget fromFooSub(FooNestedSource source) {
    final barsuboutput = BarNestedTarget(source.text, source.number);
    return barsuboutput;
  }
}
