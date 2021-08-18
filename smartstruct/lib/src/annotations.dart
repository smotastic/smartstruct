/// Main Mapper Annotation.
///
/// Annotate your interface with [mapper], and run your build_runner to generate an implemented mapperclass of this interface.
class Mapper {
  final bool useInjection;
  final bool caseSensitiveFields;

  const Mapper({this.useInjection = false, this.caseSensitiveFields = false});
}

const mapper = Mapper();

/// Mapping Annotation to support explicit field mapping in case the mapped source and target attribute do not match in name
///
/// Annotate the method with [Mapping] and provide a valid source and target fieldname to map these two fields with each other
class Mapping {
  final String source;
  final String target;
  const Mapping({required this.source, required this.target});
}

/// CustomMapping to support explicit field mapping in case the mapped target do not match in name,type or target is created based on few fields
///
/// Annotate the method with [CustomMapping] and provide a valid targetField and mapping function f
/// To achive type safety, override CustomMapping class with specific TargetField and SourceClass types
class CustomMapping<TargetField, SourceClass> {
  final String targetField;
  final TargetField Function(SourceClass) f;

  const CustomMapping({required this.targetField, required this.f});
}
