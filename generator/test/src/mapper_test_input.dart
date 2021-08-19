import 'package:smartstruct/smartstruct.dart';
import 'package:source_gen_test/source_gen_test.dart';
part 'simple_mapper_input.dart';
part 'explicit_field_mapper_input.dart';
part 'nested_mapper_input.dart';
part 'injectable_mapper_input.dart';
part 'case_sensitive_mapper_input.dart';
part 'list_mapper_input.dart';
part 'constructor_mapper_input.dart';
part 'function_mapper_input.dart';

@ShouldThrow('theAnswer is not a class and cannot be annotated with @Mapper')
@Mapper()
const theAnswer = 42;

class NoReturnTypeSource {}

@Mapper()
@ShouldThrow('void is not a valid return type')
abstract class NoReturnTypeMapper {
  void fromSource(NoReturnTypeSource source);
}
