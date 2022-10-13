part of 'mapper_test_input.dart';

class NullableListSource {
  final List<ListSubSource?> sourceNullableList;
  final List<ListSubSource> targetNullableList;
  final List<ListSubSource?> nullableList;

  NullableListSource(this.sourceNullableList, this.targetNullableList, this.nullableList);
}

class NullableListTarget {

  final List<ListSubTarget> sourceNullableList;
  final List<ListSubTarget?> targetNullableList;
  final List<ListSubTarget?> nullableList;

  NullableListTarget(this.sourceNullableList, this.targetNullableList, this.nullableList);
}

@Mapper()
@ShouldGenerate('''
class NullableListMapperImpl extends NullableListMapper {
  NullableListMapperImpl() : super();

  @override
  NullableListTarget fromNullableSource(NullableListSource source) {
    final nullablelisttarget = NullableListTarget(
      (source.sourceNullableList
          .map((x) => x == null ? null : fromSubSource(x))
          .where((x) => x != null)
          .toList() as List<ListSubTarget>),
      source.targetNullableList.map((x) => fromSubSource(x)).toList(),
      source.nullableList
          .map((x) => x == null ? null : fromSubSource(x))
          .toList(),
    );
    return nullablelisttarget;
  }

  @override
  ListSubTarget fromSubSource(ListSubSource source) {
    final listsubtarget = ListSubTarget(source.text);
    return listsubtarget;
  }
}
''')
abstract class NullableListMapper {
  NullableListTarget fromNullableSource(NullableListSource source);
  ListSubTarget fromSubSource(ListSubSource source);
}
