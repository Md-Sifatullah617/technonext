import '../entities/permission_status.dart';

/// Abstract repository for permission-related operations
abstract class PermissionRepository {
  /// Check current location permission status
  Future<PermissionStatus> checkPermission();

  /// Request location permission from user
  Future<PermissionStatus> requestPermission();

  /// Open app settings for manual permission configuration
  Future<bool> openAppSettings();
}
