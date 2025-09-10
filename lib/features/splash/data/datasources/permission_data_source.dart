import 'package:geolocator/geolocator.dart';

/// Data source for location permission operations
class PermissionDataSource {
  /// Check current location permission status
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      throw Exception('Failed to check permission: $e');
    }
  }

  /// Request location permission from user
  Future<LocationPermission> requestPermission() async {
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      throw Exception('Failed to request permission: $e');
    }
  }

  /// Open app settings for manual permission configuration
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      throw Exception('Failed to open app settings: $e');
    }
  }
}
