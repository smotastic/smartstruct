// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nullable_list.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class NullableListMapperImpl extends NullableListMapper {
  NullableListMapperImpl() : super();

  @override
  NullableListTarget fromSource(NullableListSource source) {
    final nullablelisttarget = NullableListTarget(
      source.list?.map((x) => fromSubSource(x)).toList(),
      source.list2?.map((x) => fromSubSource(x)).toList() ?? [],
    );
    return nullablelisttarget;
  }

  @override
  ListSubTarget fromSubSource(ListSubSource source) {
    final listsubtarget = ListSubTarget(source.text);
    return listsubtarget;
  }
}
