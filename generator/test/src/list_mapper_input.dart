part of 'mapper_test_input.dart';

class ListSource {
  final List<ListSubSource> list;

  ListSource(this.list);
}

class ListSubSource {
  final String text;

  ListSubSource(this.text);
}

class ListTarget {
  final List<ListSubTarget> list;

  ListTarget(this.list);
}

class ListSubTarget {
  final String text;

  ListSubTarget(this.text);
}

@Mapper()
@ShouldGenerate(r'''
class ListMapperImpl extends ListMapper {
  @override
  ListTarget fromSource(ListSource source) {
    final listtarget = ListTarget(source.list.map(fromSubSource).toList());
    return listtarget;
  }

  @override
  ListSubTarget fromSubSource(ListSubSource source) {
    final listsubtarget = ListSubTarget(source.text);
    return listsubtarget;
  }
}
''')
abstract class ListMapper {
  ListTarget fromSource(ListSource source);
  ListSubTarget fromSubSource(ListSubSource source);
}
