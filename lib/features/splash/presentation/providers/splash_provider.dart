import 'package:flutter/material.dart';
import '../../domain/entities/permission_status.dart';
import '../../domain/usecases/check_location_permission_usecase.dart';

/// States for splash screen
enum SplashState {
  initial,
  animating,
  checkingPermission,
  permissionGranted,
  permissionDenied,
  permissionDeniedForever,
  error,
  navigating,
}

/// Provider for splash screen state and business logic
class SplashProvider extends ChangeNotifier {
  final CheckLocationPermissionUseCase _checkLocationPermissionUseCase;

  SplashProvider(this._checkLocationPermissionUseCase);

  SplashState _state = SplashState.initial;
  PermissionStatus? _permissionStatus;
  String? _errorMessage;

  // Getters
  SplashState get state => _state;
  PermissionStatus? get permissionStatus => _permissionStatus;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SplashState.checkingPermission;

  /// Initialize splash sequence
  void initializeSplash() {
    _setState(SplashState.animating);
  }

  /// Check location permission after animation completes
  Future<void> checkLocationPermission() async {
    _setState(SplashState.checkingPermission);

    try {
      _permissionStatus = await _checkLocationPermissionUseCase();

      if (_permissionStatus!.isGranted) {
        _setState(SplashState.permissionGranted);
      } else if (_permissionStatus!.isDeniedForever) {
        _setState(SplashState.permissionDeniedForever);
      } else {
        _setState(SplashState.permissionDenied);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SplashState.error);
    }
  }

  /// Navigate to main screen
  void navigateToMain() {
    _setState(SplashState.navigating);
  }

  /// Reset provider state
  void reset() {
    _state = SplashState.initial;
    _permissionStatus = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Private method to update state and notify listeners
  void _setState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
