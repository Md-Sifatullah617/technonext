import 'dart:math';

/// Demo configuration for route calculation without real API
/// This allows the app to run and demonstrate the architecture
/// Replace with real Google Maps API key for production use
class DemoRouteService {
  /// Simulates route calculation with demo data
  static Future<Map<String, dynamic>> getDemoRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Calculate simple straight-line distance
    final distance = _calculateDistance(originLat, originLng, destLat, destLng);
    final estimatedTime = (distance / 50 * 60)
        .round(); // Assume 50 km/h average

    return {
      'status': 'OK',
      'routes': [
        {
          'legs': [
            {
              'distance': {'text': '${distance.toStringAsFixed(1)} km'},
              'duration': {'text': '$estimatedTime min'},
            },
          ],
          'overview_polyline': {
            'points': _generateSimplePolyline(
              originLat,
              originLng,
              destLat,
              destLng,
            ),
          },
        },
      ],
    };
  }

  /// Calculate straight-line distance using Haversine formula
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Generate a simple polyline between two points
  static String _generateSimplePolyline(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // This is a simplified polyline - in real implementation, this would come from Google Directions API
    // For demo purposes, we'll create a simple encoded polyline
    return 'demo_polyline_${lat1}_${lon1}_${lat2}_$lon2';
  }

  /// Get demo address for coordinates
  static Future<String> getDemoAddress(
    double latitude,
    double longitude,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple demo address generation
    if (latitude > 23.8 &&
        latitude < 23.9 &&
        longitude > 90.4 &&
        longitude < 90.5) {
      return 'Dhaka, Bangladesh';
    } else if (latitude > 23.7 &&
        latitude < 23.8 &&
        longitude > 90.3 &&
        longitude < 90.5) {
      return 'Gulshan, Dhaka';
    } else {
      return 'Location (${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)})';
    }
  }
}
