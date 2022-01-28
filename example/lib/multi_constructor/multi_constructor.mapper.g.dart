// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_constructor.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class MultiConMapperImpl extends MultiConMapper {
  MultiConMapperImpl() : super();

  @override
  MultiConTarget fromSource(MultiConSource source) {
    final multicontarget = MultiConTarget.multi(source.text, source.number);
    return multicontarget;
  }
}
