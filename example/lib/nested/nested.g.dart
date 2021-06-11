// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class NestedMapperImpl extends NestedMapper {
  @override
  NestedTarget fromModel(NestedSource model) {
    final nestedtarget = NestedTarget(fromSubClassModel(model.subNestedSource));
    return nestedtarget;
  }

  @override
  SubNestedTarget fromSubClassModel(SubNestedSource model) {
    final subnestedtarget = SubNestedTarget(model.myProperty);
    return subnestedtarget;
  }
}
