// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_mapping.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class CustomMapperImpl extends CustomMapper {
  @override
  Target fromSource(Source source) {
    final target =
        Target(mapFullName(source), mapBirthDate(source), source.avatar);
    return target;
  }
}
