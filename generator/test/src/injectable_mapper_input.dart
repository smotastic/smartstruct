part of 'mapper_test_input.dart';

class InjectableSource {
  final String text;

  InjectableSource(this.text);
}

class InjectableTarget {
  final String text;

  InjectableTarget(this.text);
}

@Mapper(useInjection: true)
@ShouldGenerate(r'''
@LazySingleton(as: InjectableMapper)
class InjectableMapperImpl extends InjectableMapper {
  InjectableMapperImpl() : super();

  @override
  InjectableTarget fromSource(InjectableSource source) {
    final injectabletarget = InjectableTarget(source.text);
    return injectabletarget;
  }
}
''')
abstract class InjectableMapper {
  InjectableTarget fromSource(InjectableSource source);
}
