import 'package:build/build.dart';
import 'package:smartstruct/mapper_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder smartstructBuilder(BuilderOptions options) =>
    SharedPartBuilder([MapperGenerator()], 'map');
