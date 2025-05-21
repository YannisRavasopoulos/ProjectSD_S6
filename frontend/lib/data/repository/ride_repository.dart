import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/service/ride_service.dart';

class RideRepository {
  final RideService _rideService;

  RideRepository({required RideService rideService})
    : _rideService = rideService;

  Future<Ride> getRide(String rideId) async {
    try {
      return await _rideService.getRide(rideId);
    } catch (e) {
      print('Error fetching ride: $e');
      throw Exception('Failed to fetch ride');
    }
  }

  Future<List<Ride>> getRides({
    required String source,
    required String destination,
  }) async {
    try {
      return await _rideService.getRides(
        source: source,
        destination: destination,
      );
    } catch (e) {
      throw Exception('Failed to fetch rides: $e');
    }
  }
}
