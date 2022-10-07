/// Main Mapper Annotation.
///
/// Annotate your interface with [mapper], and run your build_runner to generate an implemented mapperclass of this interface.
class Mapper {
  final bool useInjection;
  final bool caseSensitiveFields;
  final bool generateStaticProxy;

  const Mapper({this.useInjection = false, this.caseSensitiveFields = false, this.generateStaticProxy = false});
}

const mapper = Mapper();

/// Mapping Annotation to support explicit field mapping in case the mapped source and target attribute do not match in name
///
/// Annotate the method with [Mapping] and provide a valid source and target fieldname to map these two fields with each other
class Mapping {
  final dynamic source;
  final String target;
  final bool ignore;
  const Mapping({required this.target, this.source, this.ignore = false});
}

/// Annotate static methods to indicate that you want a static mapper implementation to be generated for this method
///
/// Example
/// ```dart
/// @Mapper()
/// abstract class UserMapper {
///   static EnumTargetFoo mapFoo(UserSource source) => EnumTargetFoo.ONE; // no static method will be generated
///   @StaticMapping // A static helper method _$fromSourceStatic will be generated
///   static UserTarget fromSourceStatic(UserSource source) => _$fromSourceStatic(source);
///   ...
/// }
/// ```
class StaticMapping {
  const StaticMapping();
}