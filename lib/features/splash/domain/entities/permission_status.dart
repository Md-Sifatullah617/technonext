import 'package:geolocator/geolocator.dart';

/// Entity representing permission status information
class PermissionStatus {
  final LocationPermission permission;
  final bool isDeniedForever;
  final bool isGranted;
  final String message;

  const PermissionStatus({
    required this.permission,
    required this.isDeniedForever,
    required this.isGranted,
    required this.message,
  });

  factory PermissionStatus.fromLocationPermission(
    LocationPermission permission,
  ) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return const PermissionStatus(
          permission: LocationPermission.whileInUse,
          isDeniedForever: false,
          isGranted: true,
          message: 'Location permission granted',
        );
      case LocationPermission.deniedForever:
        return const PermissionStatus(
          permission: LocationPermission.deniedForever,
          isDeniedForever: true,
          isGranted: false,
          message:
              'Location permission is permanently denied. Please enable it in app settings.',
        );
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return const PermissionStatus(
          permission: LocationPermission.denied,
          isDeniedForever: false,
          isGranted: false,
          message: 'Location permission denied',
        );
    }
  }

  PermissionStatus copyWith({
    LocationPermission? permission,
    bool? isDeniedForever,
    bool? isGranted,
    String? message,
  }) {
    return PermissionStatus(
      permission: permission ?? this.permission,
      isDeniedForever: isDeniedForever ?? this.isDeniedForever,
      isGranted: isGranted ?? this.isGranted,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionStatus &&
          runtimeType == other.runtimeType &&
          permission == other.permission &&
          isDeniedForever == other.isDeniedForever &&
          isGranted == other.isGranted &&
          message == other.message;

  @override
  int get hashCode =>
      permission.hashCode ^
      isDeniedForever.hashCode ^
      isGranted.hashCode ^
      message.hashCode;

  @override
  String toString() {
    return 'PermissionStatus{permission: $permission, isDeniedForever: $isDeniedForever, isGranted: $isGranted, message: $message}';
  }
}
