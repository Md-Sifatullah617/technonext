import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../models/route_model.dart';

class RouteRemoteDataSource {
  final Dio _dio;
  final PolylinePoints _polylinePoints = PolylinePoints();

  RouteRemoteDataSource(this._dio);

  Future<RouteModel> calculateRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    try {
      print(
        'Calculating route from ($originLat, $originLng) to ($destinationLat, $destinationLng)',
      );

      final apiKey = AppConfig.googleMapsApiKey;
      const baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'origin': '$originLat,$originLng',
          'destination': '$destinationLat,$destinationLng',
          'mode': 'driving',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // Get polyline points
          final encodedPolyline = route['overview_polyline']['points'];
          final polylineCoordinates = _polylinePoints.decodePolyline(
            encodedPolyline,
          );

          List<LatLng> polylinePoints = polylineCoordinates
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          print(
            'Route calculated successfully. Distance: ${leg['distance']['text']}, Duration: ${leg['duration']['text']}',
          );

          return RouteModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            origin: LocationPointModel(
              latitude: originLat,
              longitude: originLng,
              address: leg['start_address'],
            ),
            destination: LocationPointModel(
              latitude: destinationLat,
              longitude: destinationLng,
              address: leg['end_address'],
            ),
            distance: leg['distance']['text'],
            duration: leg['duration']['text'],
            polylinePoints: polylinePoints,
            createdAt: DateTime.now(),
          );
        } else {
          throw Exception('No routes found: ${data['status']}');
        }
      } else {
        throw Exception('Failed to calculate route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calculating route: $e');
      throw Exception('Failed to calculate route: $e');
    }
  }

  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final apiKey = AppConfig.googleMapsApiKey;
      const baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

      final response = await _dio.get(
        baseUrl,
        queryParameters: {'latlng': '$latitude,$longitude', 'key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        } else {
          return 'Unknown location';
        }
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      print('Error getting address: $e');
      return 'Unknown location';
    }
  }
}
