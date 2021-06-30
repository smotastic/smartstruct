// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injectable_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

@LazySingleton(as: InjectableMapper)
class InjectableMapperImpl extends InjectableMapper {
  InjectableMapperImpl(InjectableNestedMapper _nestedMapper)
      : super(_nestedMapper);

  @override
  InjectableTarget fromSource(InjectableSource source) {
    final injectabletarget = InjectableTarget(fromNestedSource(source.nested));
    return injectabletarget;
  }
}

@LazySingleton(as: InjectableNestedMapper)
class InjectableNestedMapperImpl extends InjectableNestedMapper {
  InjectableNestedMapperImpl() : super();

  @override
  InjectableNestedTarget fromSource(InjectableNestedSource source) {
    final injectablenestedtarget = InjectableNestedTarget(source.text);
    return injectablenestedtarget;
  }
}
