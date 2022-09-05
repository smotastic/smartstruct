// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_nullable_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class NullableNestedMapperImpl extends NullableNestedMapper {
  NullableNestedMapperImpl() : super();

  @override
  NullableNestedTarget fromSource(NestedSource source) {
    final nullablenestedtarget =
        NullableNestedTarget(fromSubSource(source.nested));
    return nullablenestedtarget;
  }

  @override
  NullableNestedTarget fromNullableSource(NullableNestedSource source) {
    final nullablenestedtarget = NullableNestedTarget(
        source.nested == null ? null : fromSubSource(source.nested!));
    return nullablenestedtarget;
  }

  @override
  NestedSubTarget fromSubSource(NestedSubSource source) {
    final nestedsubtarget = NestedSubTarget();
    return nestedsubtarget;
  }
}
