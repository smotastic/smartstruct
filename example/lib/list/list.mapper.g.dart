// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class ListMapperImpl extends ListMapper {
  ListMapperImpl() : super();

  @override
  Target fromSource(Source source) {
    final target = Target(
      source.intList.map((e) => e).toList(),
      source.entryList.map((x) => fromSourceEntry(x)).toList(),
    );
    return target;
  }

  @override
  TargetEntry fromSourceEntry(SourceEntry source) {
    final targetentry = TargetEntry(source.prop);
    return targetentry;
  }
}
