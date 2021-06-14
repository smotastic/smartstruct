import 'package:analyzer/dart/element/element.dart';
import 'package:smartstruct/smartstruct.dart';
import 'package:source_gen/source_gen.dart';

/// Helper Class to read attributes out of the [Mapper] and [Mapping] Annotations
class MapperConfig {
  /// Reads the attributes given in the [Mapper] Annotation,
  /// and returns a map, where the key is the attributename, and value the value of the read attribute.
  static Map<String, dynamic> readMapperConfig(
      ConstantReader annotation, ClassElement mappingClass) {
    var mapper =
        mappingClass.metadata[0].element!.enclosingElement as ClassElement;
    final config = <String, dynamic>{};
    mapper.fields.forEach((field) {
      final configField = annotation.read(field.name).literalValue;
      config.putIfAbsent(field.name, () => configField);
    });
    return config;
  }

  /// Reads the attributes of the [Mapping] annotations of a given Method,
  /// and returns key value pairs, where the key is the source, and the value is the target attribute of the read Mapping
  static Map<String, dynamic> readMappingConfig(MethodElement method) {
    final config = <String, dynamic>{};
    final annotations = TypeChecker.fromRuntime(Mapping).annotationsOf(method);

    annotations.forEach((element) {
      var reader = ConstantReader(element);
      config[reader.read('source').stringValue] =
          reader.read('target').stringValue;
    });
    return config;
  }
}
