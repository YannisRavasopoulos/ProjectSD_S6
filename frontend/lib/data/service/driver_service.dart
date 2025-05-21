import 'package:frontend/data/model/driver.dart';

class DriverService {
  // In-memory storage for mock data
  final Map<String, Driver> _drivers = {};

  Future<Driver> getDriver(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _drivers[driverId] ?? Driver.random();
  }
}
