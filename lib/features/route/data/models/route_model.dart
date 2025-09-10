import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/location_point.dart';
import '../../domain/entities/route_info.dart';

class RouteModel {
  final String id;
  final LocationPointModel origin;
  final LocationPointModel destination;
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final DateTime createdAt;

  const RouteModel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.createdAt,
  });

  RouteModel copyWith({
    String? id,
    LocationPointModel? origin,
    LocationPointModel? destination,
    List<LatLng>? polylinePoints,
    String? distance,
    String? duration,
    DateTime? createdAt,
  }) {
    return RouteModel(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] ?? '',
      origin: LocationPointModel.fromJson(json['origin'] ?? {}),
      destination: LocationPointModel.fromJson(json['destination'] ?? {}),
      polylinePoints: (json['polylinePoints'] as List<dynamic>? ?? [])
          .map(
            (point) =>
                LatLng(point['latitude'] ?? 0.0, point['longitude'] ?? 0.0),
          )
          .toList(),
      distance: json['distance'] ?? '',
      duration: json['duration'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'polylinePoints': polylinePoints
          .map(
            (point) => {
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
          )
          .toList(),
      'distance': distance,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  RouteInfo toEntity() {
    return RouteInfo(
      id: id,
      origin: origin.toEntity(),
      destination: destination.toEntity(),
      polylinePoints: polylinePoints,
      distance: distance,
      duration: duration,
      createdAt: createdAt,
    );
  }

  factory RouteModel.fromEntity(RouteInfo entity) {
    return RouteModel(
      id: entity.id,
      origin: LocationPointModel.fromEntity(entity.origin),
      destination: LocationPointModel.fromEntity(entity.destination),
      polylinePoints: entity.polylinePoints,
      distance: entity.distance,
      duration: entity.duration,
      createdAt: entity.createdAt,
    );
  }
}

class LocationPointModel {
  final double latitude;
  final double longitude;
  final String? address;

  const LocationPointModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory LocationPointModel.fromJson(Map<String, dynamic> json) {
    return LocationPointModel(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address};
  }

  LocationPoint toEntity() {
    return LocationPoint(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  factory LocationPointModel.fromEntity(LocationPoint entity) {
    return LocationPointModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
    );
  }
}
