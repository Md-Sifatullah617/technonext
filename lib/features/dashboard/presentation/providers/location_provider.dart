import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService locationService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  LocationProvider(this.locationService) {
    fetchLocation();
  }

  Position? _position;
  LocationPermission? _permission;

  Position? get position => _position;
  LocationPermission? get permission => _permission;

  Future<void> fetchLocation() async {
    setLoading(true);
    _position = await locationService.getCurrentPosition();
    log('Location fetched: ${_position?.latitude}, ${_position?.longitude}');
    setLoading(false);
  }

  Future<void> requestLocationPermission() async {
    bool granted = false;
    while (!granted) {
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
      }
      if (_permission == LocationPermission.deniedForever) {
        // Show a dialog or message to user to enable permission from settings
        break;
      }
      if (_permission == LocationPermission.always ||
          _permission == LocationPermission.whileInUse) {
        granted = true;
        await fetchLocation();
      }
      notifyListeners();
    }
  }
}
