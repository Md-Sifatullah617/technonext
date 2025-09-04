import 'package:geolocator/geolocator.dart';

import '../../domain/services/location_service.dart';

class LocationServiceImpl implements LocationService {
  @override
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }
}
