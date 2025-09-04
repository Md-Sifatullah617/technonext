import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technonext/features/dashboard/presentation/widgets/widget_to_map_icon.dart';
import 'package:technonext/gen/assets.gen.dart';

import '../../domain/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService locationService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  BitmapDescriptor _customMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor get customMarker => _customMarker;

  Future<void> loadCustomMarker(String assetPath) async {
    _customMarker = await Image.asset(
      assetPath,
      height: 15.h,
      width: 15.w,
    ).toBitmapDescriptor();
  }

  LocationProvider(this.locationService) {
    loadCustomMarker(Assets.icons.car.path);
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
