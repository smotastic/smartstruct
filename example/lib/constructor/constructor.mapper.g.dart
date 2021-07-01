// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constructor.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class ConstructorMapperImpl extends ConstructorMapper {
  ConstructorMapperImpl(String? optionalPos, String requiredPos,
      {required String requiredNamed, String? optionalNamed})
      : super(optionalPos, requiredPos,
            requiredNamed: requiredNamed, optionalNamed: optionalNamed);

  ConstructorMapperImpl.foo(String text) : super.foo(text);

  @override
  Target fromSource(Source source) {
    final target = Target(source.text);
    return target;
  }
}
