import 'package:injectable/injectable.dart';
import 'package:smartstruct/smartstruct.dart';

import 'ent.dart';

part 'mappero.mapper.g.dart';

@Mapper(useInjection: true)
abstract class MapperExample {
  Target fromInt(Source source);
}
