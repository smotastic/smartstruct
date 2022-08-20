import 'dart:collection';

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
part 'inheritance_mapper_input.dart';
part 'multiple_source_mapper_input.dart';
part 'ignore_field_mapper_input.dart';
part 'multiple_constructor_input.dart';
part 'nested_mapper_in_mapping_input.dart';
part 'static_mapper_input.dart';
part 'collection_mapper_input.dart';
part 'nested_generic_mapper_input.dart';
part 'nullable_nested_mapper_input.dart';
part 'nested_mapping_after_function_mapping_input.dart';
part 'nullable_list_mapper_input.dart';
part 'pass_on_mapper_function_mapper_input.dart';
part 'mapper_inheritance_input.dart';

@ShouldThrow('theAnswer is not a class and cannot be annotated with @Mapper')
@Mapper()
const theAnswer = 42;

class NoReturnTypeSource {}

@Mapper()
@ShouldThrow('void is not a valid return type')
abstract class NoReturnTypeMapper {
  void fromSource(NoReturnTypeSource source);
}
