
part of 'mapper_test_input.dart';


class StaticProxyTarget {
  final String text;
  final num number;

  StaticProxyTarget(this.text, this.number);
}

class StaticProxySource {
  final String text;
  final num number;

  StaticProxySource(this.text, this.number);
}

@Mapper(generateStaticProxy: true)
@ShouldGenerate('''
class StaticProxyMapperImpl extends StaticProxyMapper {
  StaticProxyMapperImpl() : super();

  @override
  StaticProxyTarget fromSourceNormal(StaticMappingSource source) {
    final staticproxytarget = StaticProxyTarget(
      source.text,
      source.number,
    );
    return staticproxytarget;
  }
}

class StaticProxyMapper\$ {
  static final StaticProxyMapper mapper = StaticProxyMapperImpl();

  static StaticProxyTarget fromSourceNormal(StaticMappingSource source) =>
      mapper.fromSourceNormal(source);
}
''')
abstract class StaticProxyMapper {
  StaticProxyTarget fromSourceNormal(StaticMappingSource source);
}
