import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct/smartstruct.dart';
import 'package:smartstruct_generator/code_builders/class_builder.dart';
import 'package:source_gen/source_gen.dart';

import '../mapper_config.dart';

/// Codegenerator to generate implemented mapping classes
class MapperGenerator extends GeneratorForAnnotation<Mapper> {
  @override
  dynamic generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('${element.displayName} is not a class and cannot be annotated with @Mapper',
          element: element, todo: 'Add Mapper annotation to a class');
    }

    var config = MapperConfig.readMapperConfig(annotation, element);

    try {
      final mapperImpl = buildMapperClass(element, config);
      final emitter = DartEmitter();
      return '${mapperImpl.accept(emitter)}';
    } on Error catch (e) {
      print(e);
      print(e.stackTrace);
      rethrow;
    }
  }
}
