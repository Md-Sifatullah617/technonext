import 'package:uuid/uuid.dart';

import '../../domain/entities/location_point.dart';
import '../../domain/entities/route_info.dart';
import '../../domain/repositories/route_repository.dart';
import '../datasources/route_remote_data_source.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource _remoteDataSource;
  final Uuid _uuid;

  RouteRepositoryImpl(this._remoteDataSource) : _uuid = const Uuid();

  @override
  Future<RouteInfo> calculateRoute({
    required LocationPoint origin,
    required LocationPoint destination,
  }) async {
    try {
      final routeModel = await _remoteDataSource.calculateRoute(
        originLat: origin.latitude,
        originLng: origin.longitude,
        destinationLat: destination.latitude,
        destinationLng: destination.longitude,
      );

      // Create route with unique ID
      final routeWithId = routeModel.copyWith(id: _uuid.v4());

      return routeWithId.toEntity();
    } catch (e) {
      throw Exception('Failed to calculate route: $e');
    }
  }

  @override
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await _remoteDataSource.getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      return null;
    }
  }
}
