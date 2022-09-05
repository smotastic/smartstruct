
import 'package:smartstruct/smartstruct.dart';

part 'static_proxy.mapper.g.dart';

class StaticProxyTarget {
  final String text;
  final num number;

  StaticProxyTarget(this.text, this.number);
}

class StaticMappingSource {
  final String text;
  final num number;

  StaticMappingSource(this.text, this.number);
}

@Mapper(generateStaticProxy:  true)
abstract class StaticMappingMapper {
  StaticProxyTarget fromSourceNormal(StaticMappingSource source);
}