import '../entities/location_point.dart';
import '../entities/route_info.dart';

/// Abstract repository defining the contract for route operations
abstract class RouteRepository {
  /// Calculate route between two points
  Future<RouteInfo> calculateRoute({
    required LocationPoint origin,
    required LocationPoint destination,
  });

  /// Get address from coordinates (reverse geocoding)
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
}
