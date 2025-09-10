class LocationPoint {
  final double latitude;
  final double longitude;
  final String? address;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  LocationPoint copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationPoint &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ address.hashCode;

  @override
  String toString() =>
      'LocationPoint(lat: $latitude, lng: $longitude, address: $address)';
}
