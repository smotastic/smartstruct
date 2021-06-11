// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

@LazySingleton(as: ExampleMapper)
class ExampleMapperImpl extends ExampleMapper {
  @override
  BarTarget fromFoo(FooSource source) {
    final bartarget = BarTarget(source.number, source.text, source.truthy,
        named: source.named, namedTwoDiff: source.namedTwo);
    bartarget.property = source.property;
    bartarget.propertyTwoDiff = source.propertyTwo;
    bartarget.nested = fromFooSub(source.nested);
    bartarget.setterTextDiff = source.setterText;
    bartarget.setterNumber = source.setterNumber;
    return bartarget;
  }

  @override
  BarNestedTarget fromFooSub(FooNestedSource source) {
    final barnestedtarget = BarNestedTarget(source.text, source.number);
    return barnestedtarget;
  }
}
