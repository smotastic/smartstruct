import 'package:injectable/injectable.dart';
import 'package:smartstruct/smartstruct.dart';

part 'injectable_mapper.mapper.g.dart';

class InjectableSource {
  final String text;

  InjectableSource(this.text);
}

class InjectableTarget {
  final String text;

  InjectableTarget(this.text);
}

@Mapper(useInjection: true)
abstract class InjectableMapper {
  InjectableTarget fromSource(InjectableSource source);
}
