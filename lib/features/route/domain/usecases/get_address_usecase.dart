import '../repositories/route_repository.dart';

class GetAddressUseCase {
  final RouteRepository _repository;

  GetAddressUseCase(this._repository);

  Future<String?> call({
    required double latitude,
    required double longitude,
  }) async {
    return await _repository.getAddressFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
