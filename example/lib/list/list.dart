// SOURCE
import 'package:smartstruct/smartstruct.dart';

part 'list.mapper.g.dart';

class Source {
  final List<int> intList;
  final List<SourceEntry> entryList;

  Source(this.intList, this.entryList);
}

class SourceEntry {
  final String prop;

  SourceEntry(this.prop);
}

// TARGET
class Target {
  final List<int> intList;
  final List<TargetEntry> entryList;

  Target(this.intList, this.entryList);
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
