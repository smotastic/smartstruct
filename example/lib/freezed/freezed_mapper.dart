import 'package:smartstruct/smartstruct.dart';
import 'package:smartstruct_example/freezed/freezed_classes.dart';

part 'freezed_mapper.mapper.g.dart';

// Factory with positional parameters
@Mapper()
abstract class FreezedMapper {
  @Mapping(
      target: 'copyWith',
      ignore:
          true) // drawback as freezed generates a getter for the copyWith, and we have no way of determining that the copyWith shouldn't be mapped without explicitly ignoring it
  FreezedTarget fromModel(FreezedSource model);
}

// Factory with named parameters
@Mapper()
abstract class FreezedNamedMapper {
  @Mapping(target: 'copyWith', ignore: true)
  FreezedNamedTarget fromModel(FreezedNamedSource model);
}
