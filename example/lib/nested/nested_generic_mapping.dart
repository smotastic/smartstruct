import 'package:smartstruct/smartstruct.dart';
part 'nested_generic_mapping.mapper.g.dart';


class NestedGeneric<T> {

  T value;

  NestedGeneric(this.value);
}

class NestedGenericSource {
  NestedGeneric<NestedGenericSubSource> data;

  NestedGenericSource(this.data);
}


class NestedGenericSubSource {}

class NestedGenericTarget {

  NestedGenericSubTarget data;

  NestedGenericTarget(this.data);
}


class NestedGenericSubTarget {
}


@Mapper()
abstract class NestedGenericMapper {

  @Mapping(target: "data", source: "source.data.value")
  NestedGenericTarget fromSource(NestedGenericSource source);

  NestedGenericSubTarget fromSubSource(NestedGenericSubSource source);
}