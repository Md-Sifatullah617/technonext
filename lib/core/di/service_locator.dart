import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/route/data/datasources/route_remote_data_source.dart';
import '../../features/route/data/repositories/route_repository_impl.dart';
import '../../features/route/domain/repositories/route_repository.dart';
import '../../features/route/domain/usecases/calculate_route_usecase.dart';
import '../../features/route/domain/usecases/get_address_usecase.dart';
import '../../features/route/presentation/providers/route_provider.dart';
import '../../features/splash/data/datasources/permission_data_source.dart';
import '../../features/splash/data/repositories/permission_repository_impl.dart';
import '../../features/splash/domain/repositories/permission_repository.dart';
import '../../features/splash/domain/usecases/check_location_permission_usecase.dart';
import '../../features/splash/presentation/providers/splash_provider.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Setup all dependencies for the application
Future<void> setupDependencies() async {
  // Core dependencies
  await _setupCoreDependencies();

  // Feature dependencies
  await _setupRouteDependencies();
  await _setupSplashDependencies();
}

/// Setup core infrastructure dependencies
Future<void> _setupCoreDependencies() async {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => Dio());
  }
}

/// Setup route feature dependencies
Future<void> _setupRouteDependencies() async {
  // Data sources
  getIt.registerLazySingleton<RouteRemoteDataSource>(
    () => RouteRemoteDataSource(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<CalculateRouteUseCase>(
    () => CalculateRouteUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetAddressUseCase>(
    () => GetAddressUseCase(getIt()),
  );

  // Providers
  getIt.registerFactory<RouteProvider>(() => RouteProvider(getIt(), getIt()));
}

/// Setup splash feature dependencies
Future<void> _setupSplashDependencies() async {
  // Data sources
  getIt.registerLazySingleton<PermissionDataSource>(
    () => PermissionDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<CheckLocationPermissionUseCase>(
    () => CheckLocationPermissionUseCase(getIt()),
  );

  // Providers
  getIt.registerFactory<SplashProvider>(() => SplashProvider(getIt()));
}
