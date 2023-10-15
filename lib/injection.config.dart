// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'features/ble/data/repositories/ble_repository_ipml.dart' as _i5;
import 'features/ble/domain/repositories/ble_repository.dart' as _i4;
import 'injectable_modules.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final bleService = _$BleService();
    gh.lazySingleton<_i3.FlutterReactiveBle>(() => bleService.firebaseAuth);
    gh.lazySingleton<_i4.BleRepository>(() => _i5.BleRepositoryImpl(
        flutterReactiveBle: gh<_i3.FlutterReactiveBle>()));
    return this;
  }
}

class _$BleService extends _i6.BleService {}
