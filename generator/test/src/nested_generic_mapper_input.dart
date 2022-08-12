part of 'mapper_test_input.dart';

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
@ShouldGenerate('''
class NestedGenericMapperImpl extends NestedGenericMapper {
  NestedGenericMapperImpl() : super();

  @override
  NestedGenericTarget fromSource(NestedGenericSource source) {
    final nestedgenerictarget =
        NestedGenericTarget(fromSubSource(source.data.value));
    return nestedgenerictarget;
  }

  @override
  NestedGenericSubTarget fromSubSource(NestedGenericSubSource source) {
    final nestedgenericsubtarget = NestedGenericSubTarget();
    return nestedgenericsubtarget;
  }
}
''')
abstract class NestedGenericMapper {

  @Mapping(target: "data", source: "source.data.value")
  NestedGenericTarget fromSource(NestedGenericSource source);

  NestedGenericSubTarget fromSubSource(NestedGenericSubSource source);
}