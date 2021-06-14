import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'mapper_generator.dart';

/// Main Builder for the [Mapping] Annotation
Builder smartstructBuilder(BuilderOptions options) =>
    SharedPartBuilder([MapperGenerator()], 'map');
