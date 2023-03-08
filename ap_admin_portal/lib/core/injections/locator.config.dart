// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ap_admin_portal/core/data/data-source/user-ds.dart' as _i7;
import 'package:ap_admin_portal/core/data/repository/user-repo.dart' as _i8;
import 'package:ap_admin_portal/core/data/services/user-service.dart' as _i9;
import 'package:ap_admin_portal/utils/async-function.dart' as _i10;
import 'package:ap_admin_portal/utils/network/networkInfo.dart' as _i5;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i4;
import 'package:package_info_plus/package_info_plus.dart' as _i6;

import 'register_module.dart' as _i11;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.dio);
  gh.factory<_i4.InternetConnectionCheckerPlus>(
      () => registerModule.internetConnectionChecker);
  gh.lazySingleton<_i5.NetworkInfo>(
      () => _i5.NetworkInfoImpl(gh<_i4.InternetConnectionCheckerPlus>()));
  await gh.factoryAsync<_i6.PackageInfo>(
    () => registerModule.packageInfo,
    preResolve: true,
  );
  gh.lazySingleton<_i7.UserDataSource>(() => _i7.UserDataSourceImpl());
  gh.lazySingleton<_i8.UserRepository>(
      () => _i8.UserRepositoryImpl(gh<_i7.UserDataSource>()));
  gh.lazySingleton<_i9.UserService>(
      () => _i9.UserServiceImpl(gh<_i8.UserRepository>()));
  gh.lazySingleton<_i10.AsyncFunctionWrapper>(
      () => _i10.AsyncFunctionImpl(gh<_i5.NetworkInfo>()));
  return getIt;
}

class _$RegisterModule extends _i11.RegisterModule {}
