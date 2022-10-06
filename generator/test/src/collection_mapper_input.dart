part of 'mapper_test_input.dart';

class CollectionSubSource {
  final String text;

  CollectionSubSource(this.text);
}


class CollectionSubTarget {
  final String text;

  CollectionSubTarget(this.text);
}

class CustomList<T> extends ListMixin<T>{

  List list;

  CustomList(this.list);

  @override
  int get length => list.length;

  @override
  operator [](int index) {
    return list.elementAt(index);
  }

  @override
  void operator []=(int index, value) {
    list[index] = value;
  }

  @override
  set length(int newLength) {
  }
}

class CollectionSource {

  final CustomList<CollectionSubSource> customToList;
  final Set<CollectionSubSource> set;
  final Set<CollectionSubSource> setToList;
  final List<CollectionSubSource> listToSet;
  final Iterable<CollectionSubSource> iterable;

  CollectionSource(
    this.customToList,
    this.set,
    this.setToList,
    this.listToSet,
    this.iterable,
  );
}

class CollectionTarget {

  final List<CollectionSubTarget> customToList;
  final Set<CollectionSubTarget> set;
  final List<CollectionSubTarget> setToList;
  final Set<CollectionSubTarget> listToSet;
  final Iterable<CollectionSubTarget> iterable;

  CollectionTarget(
    this.customToList,
    this.set,
    this.setToList,
    this.listToSet,
    this.iterable,
  );
}


@Mapper()
@ShouldGenerate(r'''
class CollectionMapperImpl extends CollectionMapper {
  CollectionMapperImpl() : super();

  @override
  CollectionTarget fromSource(CollectionSource source) {
    final collectiontarget = CollectionTarget(
      source.customToList.map((x) => fromSubSource(x)).toList(),
      source.set.map((x) => fromSubSource(x)).toSet(),
      source.setToList.map((x) => fromSubSource(x)).toList(),
      source.listToSet.map((x) => fromSubSource(x)).toSet(),
      source.iterable.map((x) => fromSubSource(x)),
    );
    return collectiontarget;
  }

  @override
  CollectionSubTarget fromSubSource(CollectionSubSource source) {
    final collectionsubtarget = CollectionSubTarget(source.text);
    return collectionsubtarget;
  }
}
''')
abstract class CollectionMapper {
  CollectionTarget fromSource(CollectionSource source);
  CollectionSubTarget fromSubSource(CollectionSubSource source);
}
