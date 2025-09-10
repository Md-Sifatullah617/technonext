import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_point.dart';

class RouteInfo {
  final String id;
  final LocationPoint origin;
  final LocationPoint destination;
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final DateTime createdAt;

  const RouteInfo({
    required this.id,
    required this.origin,
    required this.destination,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.createdAt,
  });

  RouteInfo copyWith({
    String? id,
    LocationPoint? origin,
    LocationPoint? destination,
    List<LatLng>? polylinePoints,
    String? distance,
    String? duration,
    DateTime? createdAt,
  }) {
    return RouteInfo(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteInfo &&
        other.id == id &&
        other.origin == origin &&
        other.destination == destination &&
        other.distance == distance &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        origin.hashCode ^
        destination.hashCode ^
        distance.hashCode ^
        duration.hashCode;
  }

  @override
  String toString() {
    return 'RouteInfo(id: $id, origin: $origin, destination: $destination, distance: $distance, duration: $duration)';
  }
}
