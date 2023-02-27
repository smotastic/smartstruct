// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_sources.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class MultipleSourcesMapperImpl extends MultipleSourcesMapper {
  MultipleSourcesMapperImpl() : super();

  @override
  Target fromSource(
    Source source,
    Source2 source2,
    Source3 source3,
  ) {
    final target = Target(
      source.text1,
      source2.text2,
      source3.text3,
      allText(
        source,
        source2,
        source3,
      ),
    );
    return target;
  }
}
