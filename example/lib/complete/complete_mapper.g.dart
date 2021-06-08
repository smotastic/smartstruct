// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

@LazySingleton(as: ExampleMapper)
class ExampleMapperImpl extends ExampleMapper {
  @override
  BarOutput fromFoo(FooInput input) {
    final baroutput = BarOutput(input.number, input.text, input.truthy,
        named: input.named, namedTwoDiff: input.namedTwo);
    baroutput.property = input.property;
    baroutput.propertyTwoDiff = input.propertyTwo;
    baroutput.setterTextDiff = input.setterText;
    baroutput.setterNumber = input.setterNumber;
    return baroutput;
  }
}
