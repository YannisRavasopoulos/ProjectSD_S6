import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:latlong2/latlong.dart';

class MockLocation extends Location {
  @override
  final LatLng coordinates;
  @override
  final int id = 0;

  MockLocation({required this.coordinates});

  static int i = 0;

  factory MockLocation.random() {
    // Oscillate latitude slightly using current time in seconds
    // final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final delta = 0.000005 * i++;
    // final delta = 0.0005 * (now % 5 == 0 ? 1 : -1);
    return MockLocation(coordinates: LatLng(38.268763 + delta, 21.748858));
  }
}

class MockLocationRepository implements LocationRepository {
  @override
  Future<Location> fetchCurrent(User user) async {
    return MockLocation.random();
  }

  @override
  Stream<Location> watchCurrent(User user) async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 100));
      yield await fetchCurrent(user);
    }
  }

  @override
  Future<Location> fetchForQuery(String query) async {
    // For simplicity, return a fixed location for any query
    return MockLocation(coordinates: LatLng(38.268763, 21.748858));
  }
}
