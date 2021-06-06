// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class ExampleMapperImpl extends ExampleMapper {
  @override
  BarOutput fromFoo(FooInput input) {
    final baroutput = BarOutput(
        input.someNumber, input.someString, input.someBool,
        finalNamed: input.finalNamed);
    baroutput.nonFinalProperty = input.nonFinalProperty;
    baroutput.nonFinalSetter = input.nonFinalSetter;
    return baroutput;
  }
}
