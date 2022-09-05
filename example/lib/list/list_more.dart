// SOURCE
import 'dart:collection';

import 'package:smartstruct/smartstruct.dart';

part 'list_more.mapper.g.dart';

class Source {
  final List<int> intList;
  final List<SourceEntry> entryList;
  final Iterable<SourceEntry> entryList2;
  final Set<SourceEntry> entryList3;
  final CustomList<SourceEntry> entryList4;
  final List<SourceEntry?> entryList5;

  Source(this.intList, this.entryList, this.entryList2, this.entryList3, this.entryList4,  this.entryList5);
}

class SourceEntry {
  final String prop;

  SourceEntry(this.prop);
}

// TARGET
class Target {
  late List<int> intList;
  late List<TargetEntry> entryList;
  late Set<TargetEntry> entryList2;
  late Iterable<TargetEntry> entryList3;
  late Iterable<TargetEntry> entryList4;
  late Set<TargetEntry> entryList5;

  Target();
}

class TargetEntry {
  final String prop;

  TargetEntry(this.prop);
}

@Mapper()
abstract class ListMapper {
  Target fromSource(Source source);
  TargetEntry fromSourceEntry(SourceEntry source);
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