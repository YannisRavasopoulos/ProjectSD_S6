import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'package:frontend/data/service/ride_service.dart';

class RideRepository {
  final List<Ride> _createdRides = [];

  Future<void> createRide({
    required String source,
    required String destination,
    required DateTime departureTime,
    required int passengers,
    required int capacity,
    String? description,
  }) async {
    final ride = Ride(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      source: source,
      destination: destination,
      departureTime: departureTime,
      passengers: passengers,
      capacity: capacity,
      description: description ?? '',
      driver: Driver.random(),
      vehicle: Vehicle.random(),
      distance: '',
      estimatedDuration: '',
    );
    _createdRides.add(ride);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  List<Ride> getCreatedRides() => List.unmodifiable(_createdRides);




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

  Future<void> insertRide(Ride ride) async {
    _createdRides.add(ride);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> removeRide(String id) async {
    _createdRides.removeWhere((ride) => ride.id == id);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<List<Ride>> fetchCreatedRides() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_createdRides);
  }
}
