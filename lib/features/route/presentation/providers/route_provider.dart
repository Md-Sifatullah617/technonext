import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/location_point.dart';
import '../../domain/entities/route_info.dart';
import '../../domain/usecases/calculate_route_usecase.dart';
import '../../domain/usecases/get_address_usecase.dart';

enum RouteState { idle, loading, calculating, success, error }

class RouteProvider extends ChangeNotifier {
  final CalculateRouteUseCase _calculateRouteUseCase;
  final GetAddressUseCase _getAddressUseCase;

  RouteProvider(this._calculateRouteUseCase, this._getAddressUseCase);

  // State
  RouteState _state = RouteState.idle;
  String _errorMessage = '';
  LocationPoint? _origin;
  LocationPoint? _destination;
  RouteInfo? _currentRoute;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  MapType _mapType = MapType.normal;

  // Getters
  RouteState get state => _state;
  String get errorMessage => _errorMessage;
  LocationPoint? get origin => _origin;
  LocationPoint? get destination => _destination;
  RouteInfo? get currentRoute => _currentRoute;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  MapType get mapType => _mapType;

  bool get canCalculateRoute => _origin != null && _destination != null;
  bool get hasRoute => _currentRoute != null;

  void _setState(RouteState newState, {String errorMessage = ''}) {
    _state = newState;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  /// Set origin point
  Future<void> setOrigin(double latitude, double longitude) async {
    _setState(RouteState.loading);

    try {
      final address = await _getAddressUseCase(
        latitude: latitude,
        longitude: longitude,
      );

      _origin = LocationPoint(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      await _updateMarkers();
      _setState(RouteState.idle);

      // Auto-calculate route if destination is already set
      if (_destination != null) {
        await calculateRoute();
      }
    } catch (e) {
      _setState(RouteState.error, errorMessage: 'Failed to set origin: $e');
    }
  }

  /// Set destination point
  Future<void> setDestination(double latitude, double longitude) async {
    _setState(RouteState.loading);

    try {
      final address = await _getAddressUseCase(
        latitude: latitude,
        longitude: longitude,
      );

      _destination = LocationPoint(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      await _updateMarkers();
      _setState(RouteState.idle);

      // Auto-calculate route if origin is already set
      if (_origin != null) {
        await calculateRoute();
      }
    } catch (e) {
      _setState(
        RouteState.error,
        errorMessage: 'Failed to set destination: $e',
      );
    }
  }

  /// Calculate route between origin and destination
  Future<void> calculateRoute() async {
    if (!canCalculateRoute) return;

    _setState(RouteState.calculating);

    try {
      final route = await _calculateRouteUseCase(
        origin: _origin!,
        destination: _destination!,
      );

      _currentRoute = route;
      await _updatePolylines();
      _setState(RouteState.success);
    } catch (e) {
      _setState(
        RouteState.error,
        errorMessage: 'Failed to calculate route: $e',
      );
    }
  }

  /// Clear all data
  void clearRoute() {
    _origin = null;
    _destination = null;
    _currentRoute = null;
    _markers.clear();
    _polylines.clear();
    _setState(RouteState.idle);
  }

  /// Clear only the route but keep origin and destination
  void clearRouteOnly() {
    _currentRoute = null;
    _polylines.clear();
    _setState(RouteState.idle);
  }

  /// Update markers on the map
  Future<void> _updateMarkers() async {
    _markers.clear();

    if (_origin != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(_origin!.latitude, _origin!.longitude),
          infoWindow: InfoWindow(
            title: 'Origin',
            snippet: _origin!.address ?? 'Selected location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    if (_destination != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(_destination!.latitude, _destination!.longitude),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destination!.address ?? 'Selected location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  /// Update polylines on the map
  Future<void> _updatePolylines() async {
    _polylines.clear();

    if (_currentRoute != null && _currentRoute!.polylinePoints.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _currentRoute!.polylinePoints,
          color: Colors.blue,
          width: 4,
          patterns: [],
          geodesic: true, // Follow Earth's curvature for more accurate routes
        ),
      );

      print(
        'Added polyline with ${_currentRoute!.polylinePoints.length} points',
      );
    }
  }

  /// Handle map tap for setting points
  Future<void> handleMapTap(LatLng position) async {
    if (_origin == null) {
      await setOrigin(position.latitude, position.longitude);
    } else if (_destination == null) {
      await setDestination(position.latitude, position.longitude);
    } else {
      // If both points are set, clear and set new origin
      clearRoute();
      await setOrigin(position.latitude, position.longitude);
    }
  }

  /// Change map type
  void changeMapType(MapType newMapType) {
    _mapType = newMapType;
    notifyListeners();
  }

  /// Get available map types with display names
  List<MapTypeInfo> getAvailableMapTypes() {
    return [
      MapTypeInfo(MapType.normal, 'Normal', Icons.map),
      MapTypeInfo(MapType.satellite, 'Satellite', Icons.satellite_alt),
      MapTypeInfo(MapType.hybrid, 'Hybrid', Icons.layers),
      MapTypeInfo(MapType.terrain, 'Terrain', Icons.terrain),
    ];
  }
}

/// Map type information for UI display
class MapTypeInfo {
  final MapType type;
  final String name;
  final IconData icon;

  MapTypeInfo(this.type, this.name, this.icon);
}
