import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';

class PickupRepository {
  final PickupService _pickupService;

  PickupRepository({required PickupService pickupService})
    : _pickupService = pickupService;

  Future<bool> createPickupRequest({
    required String carpoolerId,
    required Driver driver,
    required Ride ride,
    required DateTime pickupTime,
    required String location,
  }) async {
    try {
      final response = await _pickupService.createPickup(
        carpoolerId: carpoolerId,
        driver: driver,
        ride: ride,
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
