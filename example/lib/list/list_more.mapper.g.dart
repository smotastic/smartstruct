// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_more.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class ListMapperImpl extends ListMapper {
  ListMapperImpl() : super();

  @override
  Target fromSource(Source source) {
    final target = Target();
    target.intList = source.intList.map((e) => e).toList();
    target.entryList = source.entryList.map((x) => fromSourceEntry(x)).toList();
    target.entryList2 =
        source.entryList2.map((x) => fromSourceEntry(x)).toSet();
    target.entryList3 = source.entryList3.map((x) => fromSourceEntry(x));
    target.entryList4 = source.entryList4.map((x) => fromSourceEntry(x));
    target.entryList5 = (source.entryList5
        .map((x) => x == null ? null : fromSourceEntry(x))
        .where((x) => x != null)
        .toSet() as Set<TargetEntry>);
    return target;
  }

  @override
  TargetEntry fromSourceEntry(SourceEntry source) {
    final targetentry = TargetEntry(source.prop);
    return targetentry;
  }
}
