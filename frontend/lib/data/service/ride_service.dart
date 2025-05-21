import 'package:frontend/data/model/ride.dart';

class RideService {
  // In-memory storage for mock data
  final Map<String, Ride> _rides = {};

  Future<Ride> getRide(String rideId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _rides[rideId] ?? Ride.random();
  }

  Future<List<Ride>> getRides({
    required String source,
    required String destination,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.generate(10, (index) => Ride.random());
  }
}
