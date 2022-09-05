
import 'package:smartstruct/smartstruct.dart';
part 'nested_mapping_after_function_mapping.mapper.g.dart';

class NestedSubSourceRef {
  final NestedSubSource _subSource;

  NestedSubSourceRef(this._subSource);

  getSubSource() {
    return _subSource;
  }
}

class NestedSubSource {
}

class NestedRefSource {
  NestedSubSourceRef ref;

  NestedRefSource(this.ref);
}

class NestedSubTarget {
}

class NestedTarget {
    NestedSubTarget nested;

    NestedTarget(this.nested);
}

@Mapper()
abstract class NestedMappingAfterFunctionMappingMapper {

  // The mapRef return a NestedSubSource and the target field type is
  // NestedSubTarget. So the SmartStruct will apply the nested mapping
  // "fromSubSource".
  @Mapping(target: "nested", source: mapRef)
  NestedTarget fromRefSource(NestedRefSource source);

  NestedSubTarget fromSubSource(NestedSubSource source);

}


NestedSubSource mapRef(NestedRefSource source) => source.ref.getSubSource();