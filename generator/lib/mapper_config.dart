import 'package:analyzer/dart/constant/value.dart';
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

    for (final field in mapper.fields) {
      final configField = annotation.read(field.name).literalValue;
      config.putIfAbsent(field.name, () => configField);
    }
    return config;
  }

  /// Reads the attributes of the [Mapping] annotations of a given Method,
  /// and returns key value pairs, where the key is the target, and the value is an instance of [MappingConfig] containing the source and other meta attributes
  static Map<String, MappingConfig> readMappingConfig(MethodElement method) {
    final config = <String, MappingConfig>{};
    final annotations = TypeChecker.fromRuntime(Mapping).annotationsOf(method);

    for (final element in annotations) {
      final reader = ConstantReader(element);
      final sourceReader = reader.read('source');
      config[reader.read('target').stringValue] = MappingConfig(
          sourceReader.isNull ? null : sourceReader.objectValue,
          reader.read('ignore').boolValue);
    }
    return config;
  }

  static bool isIgnoreMapping(MethodElement method) {
    final annotations =
        TypeChecker.fromRuntime(IgnoreMapping).annotationsOf(method);
    return annotations.isNotEmpty;
  }
}

class MappingConfig {
  final DartObject? source;
  final bool ignore;

  MappingConfig(this.source, this.ignore);
}
