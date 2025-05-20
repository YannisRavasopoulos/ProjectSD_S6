import 'package:frontend/data/service/notification_service.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';

class PickupService {
  final NotificationService _notificationService = NotificationService();

  // In-memory storage for mock data
  final List<Map<String, dynamic>> _pickups = [];

  Future<Map<String, dynamic>> createPickup({
    required String carpoolerId,
    required Driver driver,
    required Ride ride,
    required DateTime pickupTime,
    required String location,
  }) async {
    //delay
    await Future.delayed(const Duration(seconds: 1));

    final pickup = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'carpooler_id': carpoolerId,
      'driver': driver,
      'ride': ride.toJson(), // Add ride data
      'pickup_time': pickupTime.toIso8601String(),
      'location': location,
      'status': 'pending',
    };

    _pickups.add(pickup);
    return {'success': true, 'data': pickup};
  }

  Future<List<Map<String, dynamic>>> getDriverPickups(String driver) async {
    //ksana delay
    await Future.delayed(const Duration(seconds: 1));

    return _pickups.where((pickup) => pickup['driver'] == driver).toList();
  }

  Future<bool> updatePickupStatus({
    required String pickupId,
    required String status,
  }) async {
    //ksana delay
    await Future.delayed(const Duration(milliseconds: 500));

    final pickupIndex = _pickups.indexWhere((p) => p['id'] == pickupId);
    if (pickupIndex != -1) {
      _pickups[pickupIndex]['status'] = status;
      return true;
    }
    return false;
  }

  // Used by carpooler to request a pickup
  Future<Map<String, dynamic>> requestPickup({
    required String carpoolerId,
    required Driver driver,
    required Ride ride,
    required DateTime pickupTime,
    required String location,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final pickup = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'carpooler_id': carpoolerId,
      'driver': driver,
      'ride': ride.toJson(),
      'pickup_time': pickupTime.toIso8601String(),
      'location': location,
      'status': 'requested',
    };

    _pickups.add(pickup);
    _notificationService.sendPickupRequest(Pickup.fromJson(pickup));

    return {'success': true, 'data': pickup};
  }
}
