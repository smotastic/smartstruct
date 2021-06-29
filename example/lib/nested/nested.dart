import 'package:smartstruct/smartstruct.dart';

part 'nested.mapper.g.dart';

// TARGET

class NestedTarget {
  NestedTarget(this.subNestedTarget);

  final SubNestedTarget subNestedTarget;
}

class SubNestedTarget {
  SubNestedTarget(this.myProperty);

  final String myProperty;
}

// SOURCE

class NestedSource {
  NestedSource(this.subNestedSource);

  final SubNestedSource subNestedSource;
}

class SubNestedSource {
  SubNestedSource(this.myProperty);

  final String myProperty;
}

/// Mapper showcasing how to map nested classes
@Mapper()
abstract class NestedMapper {
  @Mapping(source: 'subNestedSource', target: 'subNestedTarget')
  NestedTarget fromModel(NestedSource model);

  SubNestedTarget fromSubClassModel(SubNestedSource model);
}
