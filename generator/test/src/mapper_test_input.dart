import 'package:smartstruct/smartstruct.dart';
import 'package:source_gen_test/source_gen_test.dart';

part 'simple_mapper_input.dart';

@ShouldThrow('theAnswer is not a class and cannot be annotated with @Mapper')
@Mapper()
const theAnswer = 42;
