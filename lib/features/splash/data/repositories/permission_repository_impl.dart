import '../../domain/entities/permission_status.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_data_source.dart';

/// Implementation of permission repository
class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionDataSource _dataSource;

  PermissionRepositoryImpl(this._dataSource);

  @override
  Future<PermissionStatus> checkPermission() async {
    try {
      final permission = await _dataSource.checkPermission();
      return PermissionStatus.fromLocationPermission(permission);
    } catch (e) {
      throw Exception('Failed to check permission: $e');
    }
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    try {
      final permission = await _dataSource.requestPermission();
      return PermissionStatus.fromLocationPermission(permission);
    } catch (e) {
      throw Exception('Failed to request permission: $e');
    }
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      return await _dataSource.openAppSettings();
    } catch (e) {
      throw Exception('Failed to open app settings: $e');
    }
  }
}
