class PickupService {
  // In-memory storage for mock data
  final List<Map<String, dynamic>> _pickups = [];

  Future<Map<String, dynamic>> createPickup({
    required String carpoolerId,
    required String driverId,
    required DateTime pickupTime,
    required String location,
  }) async {
    //delay
    await Future.delayed(const Duration(seconds: 1));

    final pickup = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'carpooler_id': carpoolerId,
      'driver_id': driverId,
      'pickup_time': pickupTime.toIso8601String(),
      'location': location,
      'status': 'pending',
    };

    _pickups.add(pickup);
    return {'success': true, 'data': pickup};
  }

  Future<List<Map<String, dynamic>>> getDriverPickups(String driverId) async {
    //ksana delay
    await Future.delayed(const Duration(seconds: 1));

    return _pickups.where((pickup) => pickup['driver_id'] == driverId).toList();
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
}
