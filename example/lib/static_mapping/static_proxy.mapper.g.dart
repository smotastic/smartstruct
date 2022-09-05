// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_proxy.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class StaticMappingMapperImpl extends StaticMappingMapper {
  StaticMappingMapperImpl() : super();

  @override
  StaticProxyTarget fromSourceNormal(StaticMappingSource source) {
    final staticproxytarget = StaticProxyTarget(source.text, source.number);
    return staticproxytarget;
  }
}

class StaticMappingMapper$ {
  static final StaticMappingMapper mapper = StaticMappingMapperImpl();

  static StaticProxyTarget fromSourceNormal(StaticMappingSource source) =>
      mapper.fromSourceNormal(source);
}
