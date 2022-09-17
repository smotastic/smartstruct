// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

@LazySingleton(as: ExampleMapper)
class ExampleMapperImpl extends ExampleMapper {
  ExampleMapperImpl() : super();

  @override
  BarTarget fromFoo(
    FooSource source,
    FooSourceTheSecond second,
  ) {
    final bartarget = BarTarget(
      source.number,
      source.text,
      source.truthy,
      source.superText,
      named: source.named,
      namedTwoDiff: source.namedTwo,
      list: source.list.map((x) => fromFooSub(x)).toList(),
      secondTextOther: second.secondTextOther,
    );
    bartarget.property = source.property;
    bartarget.propertyTwoDiff = source.propertyTwo;
    bartarget.nested = fromFooSub(source.nested);
    bartarget.superPropertySet = source.superPropertySet;
    bartarget.secondText = second.secondText;
    bartarget.setterTextDiff = source.setterText;
    bartarget.setterNumber = source.setterNumber;
    return bartarget;
  }

  @override
  BarNestedTarget fromFooSub(FooNestedSource source) {
    final barnestedtarget = BarNestedTarget(
      source.text,
      source.number,
    );
    return barnestedtarget;
  }
}
