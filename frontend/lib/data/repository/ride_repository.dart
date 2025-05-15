import 'package:frontend/data/model/ride.dart';

class RideRepository {
  Future<List<Ride>> getRides({
    required String source,
    required String destination,
  }) async {
    try {
      // final rides = await rideApi.getRides(
      //   source: source,
      //   destination: destination,
      // );
      return List.generate(10, (index) => Ride.random());
    } catch (e) {
      throw Exception('Failed to fetch rides: $e');
    }
  }
}
