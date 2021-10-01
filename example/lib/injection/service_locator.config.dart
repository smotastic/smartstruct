// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../complete/complete.dart' as _i3;
import 'injectable_mapper.dart' as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.ExampleMapper>(() => _i3.ExampleMapperImpl());
  gh.lazySingleton<_i4.InjectableNestedMapper>(
      () => _i4.InjectableNestedMapperImpl());
  gh.lazySingleton<_i4.InjectableMapper>(
      () => _i4.InjectableMapperImpl(get<_i4.InjectableNestedMapper>()));
  return get;
}
