import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'mapper_generator.dart';

Builder smartstructBuilder(BuilderOptions options) =>
    SharedPartBuilder([MapperGenerator()], 'map');
