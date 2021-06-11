class Mapper {
  final bool useInjection;

  const Mapper({this.useInjection = false});
}

class Mapping {
  final String source;
  final String target;
  const Mapping({required this.source, required this.target});
}
