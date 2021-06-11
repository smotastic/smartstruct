import 'package:analyzer/dart/element/element.dart';
import 'package:smartstruct/smartstruct.dart';
import 'package:source_gen/source_gen.dart';

class MapperConfig {
  static Map<String, dynamic> readClassConfig(
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

  static Map<String, dynamic> readMethodConfig(MethodElement method) {
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
