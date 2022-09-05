// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_generic_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class NestedGenericMapperImpl extends NestedGenericMapper {
  NestedGenericMapperImpl() : super();

  @override
  NestedGenericTarget fromSource(NestedGenericSource source) {
    final nestedgenerictarget =
        NestedGenericTarget(fromSubSource(source.data.value));
    return nestedgenerictarget;
  }

  @override
  NestedGenericSubTarget fromSubSource(NestedGenericSubSource source) {
    final nestedgenericsubtarget = NestedGenericSubTarget();
    return nestedgenericsubtarget;
  }
}
