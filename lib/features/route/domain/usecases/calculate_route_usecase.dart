import '../entities/location_point.dart';
import '../entities/route_info.dart';
import '../repositories/route_repository.dart';

class CalculateRouteUseCase {
  final RouteRepository _repository;

  CalculateRouteUseCase(this._repository);

  Future<RouteInfo> call({
    required LocationPoint origin,
    required LocationPoint destination,
  }) async {
    return await _repository.calculateRoute(
      origin: origin,
      destination: destination,
    );
  }
}
