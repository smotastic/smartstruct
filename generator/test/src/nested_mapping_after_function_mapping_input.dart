part of 'mapper_test_input.dart';

class NestedSubSourceRef {
  final NestedSubSource _subSource;
  NestedSubSourceRef sourceNullableRef;

  NestedSubSourceRef(this._subSource, this.sourceNullableRef);

  getSubSource() {
    return _subSource;
  }
}

class NestedRefSource {
  NestedSubSourceRef ref;

  NestedRefSource(this.ref);
}

class NullableNestedRefSource {
  NestedSubSourceRef? ref;

  NullableNestedRefSource(this.ref);
}


@Mapper()
@ShouldGenerate('''
class NestedMappingAfterFunctionMappingMapperImpl
    extends NestedMappingAfterFunctionMappingMapper {
  NestedMappingAfterFunctionMappingMapperImpl() : super();

  @override
  NestedTarget fromRefSource(NestedRefSource source) {
    final nestedtarget = NestedTarget(fromSubSource(mapRef(source)));
    return nestedtarget;
  }

  @override
  NullableNestedTarget fromRefSource2(NullableNestedRefSource source) {
    final nullablenestedtarget = NullableNestedTarget(() {
      final tmp = nullableMapRef(source);
      return tmp == null ? null : fromSubSource(tmp);
    }());
    return nullablenestedtarget;
  }

  @override
  NestedSubTarget fromSubSource(NestedSubSource source) {
    final nestedsubtarget = NestedSubTarget(source.text);
    return nestedsubtarget;
  }
}
''')
abstract class NestedMappingAfterFunctionMappingMapper {

  @Mapping(target: "nested", source: mapRef)
  NestedTarget fromRefSource(NestedRefSource source);

  @Mapping(target: "nested", source: nullableMapRef)
  NullableNestedTarget fromRefSource2(NullableNestedRefSource source);

  NestedSubTarget fromSubSource(NestedSubSource source);

}

NestedSubSource mapRef(NestedRefSource source) => source.ref.getSubSource();
NestedSubSource? nullableMapRef(NullableNestedRefSource source) => source.ref?.getSubSource();