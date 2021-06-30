import 'package:injectable/injectable.dart';
import 'package:smartstruct/smartstruct.dart';

part 'injectable_mapper.mapper.g.dart';

class InjectableSource {
  final InjectableNestedSource nested;

  InjectableSource(this.nested);
}

class InjectableNestedSource {
  final String text;

  InjectableNestedSource(this.text);
}

class InjectableTarget {
  final InjectableNestedTarget nested;

  InjectableTarget(this.nested);
}

class InjectableNestedTarget {
  final String text;

  InjectableNestedTarget(this.text);
}

@Mapper(useInjection: true)
abstract class InjectableMapper {
  InjectableNestedMapper _nestedMapper;
  InjectableMapper(this._nestedMapper);

  InjectableTarget fromSource(InjectableSource source);
  InjectableNestedTarget fromNestedSource(InjectableNestedSource source) {
    return _nestedMapper.fromSource(source);
  }
}

@Mapper(useInjection: true)
abstract class InjectableNestedMapper {
  InjectableNestedTarget fromSource(InjectableNestedSource source);
}
