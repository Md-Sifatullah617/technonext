import '../entities/permission_status.dart';
import '../repositories/permission_repository.dart';

/// Use case for checking and requesting location permission
class CheckLocationPermissionUseCase {
  final PermissionRepository _repository;

  CheckLocationPermissionUseCase(this._repository);

  Future<PermissionStatus> call() async {
    try {
      // First check current permission status
      final currentStatus = await _repository.checkPermission();

      // If permission is denied but not permanently, try to request it
      if (!currentStatus.isGranted && !currentStatus.isDeniedForever) {
        return await _repository.requestPermission();
      }

      return currentStatus;
    } catch (e) {
      throw Exception('Failed to check location permission: $e');
    }
  }
}

/// Use case for opening app settings
class OpenAppSettingsUseCase {
  final PermissionRepository _repository;

  OpenAppSettingsUseCase(this._repository);

  Future<bool> call() async {
    try {
      return await _repository.openAppSettings();
    } catch (e) {
      throw Exception('Failed to open app settings: $e');
    }
  }
}
