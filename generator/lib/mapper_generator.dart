import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct/annotations.dart';
import 'package:source_gen/source_gen.dart';

class MapperGenerator extends GeneratorForAnnotation<Mapper> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final animal = Class((b) => b
      ..name = 'Animal'
      // ..extend = refer('Organism')
      ..methods.add(Method.returnsVoid((b) => b
        ..name = 'eat'
        ..body = const Code("print('Yum');"))));
    final emitter = DartEmitter();
    return '${animal.accept(emitter)}';
  }
}
