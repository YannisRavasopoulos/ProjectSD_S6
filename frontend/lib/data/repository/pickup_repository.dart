import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/service/pickup_service.dart';

class PickupRepository {
  final PickupService _pickupService;

  PickupRepository({required PickupService pickupService})
    : _pickupService = pickupService;

  Future<bool> createPickupRequest({
    required String carpoolerId,
    required String driverId,
    required DateTime pickupTime,
    required String location,
  }) async {
    try {
      final response = await _pickupService.createPickup(
        carpoolerId: carpoolerId,
        driverId: driverId,
        pickupTime: pickupTime,
        location: location,
      );

      return response['success'] ?? false;
    } catch (e) {
      print('Error creating pickup request: $e');
      return false;
    }
  }
}
