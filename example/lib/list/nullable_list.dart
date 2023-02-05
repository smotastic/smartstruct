import 'package:smartstruct/smartstruct.dart';

part 'nullable_list.mapper.g.dart';

class NullableListSource {
  final List<ListSubSource>? list;
  final List<ListSubSource>? list2;

  NullableListSource(this.list, this.list2);
}

class ListSubSource {
  final String text;

  ListSubSource(this.text);
}

class NullableListTarget {
  final List<ListSubTarget>? list;
  final List<ListSubTarget> list2;

  NullableListTarget(this.list, this.list2);
}

class ListSubTarget {
  final String text;

  ListSubTarget(this.text);
}

@Mapper()
abstract class NullableListMapper {
  NullableListTarget fromSource(NullableListSource source);
  ListSubTarget fromSubSource(ListSubSource source);
}
