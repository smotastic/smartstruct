import 'package:smartstruct_generator/generators/mapper_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  initializeBuildLogTracking();
  final reader = await initializeLibraryReaderForDirectory(
    p.join('test', 'src'),
    'mapper_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    MapperGenerator(),
    expectedAnnotatedTests: _expectedAnnotatedTests,
  );
}

const _expectedAnnotatedTests = {
  'theAnswer',
  'NoReturnTypeMapper',
  'SimpleMapper',
  'ExplicitFieldMapper',
  'NestedMapper',
  'NullableNestedMapper',
  'NestedMappingAfterFunctionMappingMapper',
  'InjectableMapper',
  'ListMapper',
  'NullableListMapper',
  "CollectionMapper",
  'CaseInsensitiveMapper',
  'CaseSensitiveMapper',
  'CaseSensitiveDuplicateMapper',
  'ConstructorMapper',
  'FunctionFieldMapper',
  'InheritanceMapper',
  'MultipleSourceMapper',
  'IgnoreMapper',
  'MultiConMapper',
  'NestedMappingMapper',
  'StaticMappingMapper',
  'NestedGenericMapper',
  'PassOnMapperFunctionMapper',
  'MapperInheritanceMapper',
};
