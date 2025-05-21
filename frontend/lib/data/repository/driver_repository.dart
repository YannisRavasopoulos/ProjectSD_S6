import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/service/driver_service.dart';

class DriverRepository {
  final DriverService _driverService;

  DriverRepository({required DriverService driverService})
    : _driverService = driverService;

  Future<Driver> getDriver(String driverId) async {
    try {
      return await _driverService.getDriver(driverId);
    } catch (e) {
      print('Error fetching driver: $e');
      throw Exception('Failed to fetch driver');
    }
  }
}
