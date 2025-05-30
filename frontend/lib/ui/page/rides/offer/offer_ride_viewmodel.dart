import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class OfferRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;

  List<Ride> rides = [];
  Map<int, List<Passenger>> matchingPassengers = {};

  OfferRideViewModel({required this.rideRepository});

  Future<void> loadRides() async {
    // You may want to pass a RideRequest or filter here
    rides = await rideRepository.fetchHistory();
    notifyListeners();
  }

  Future<void> loadMatchingPassengers(Ride ride) async {
    final passengers = await rideRepository.fetchPotentialPassengers(ride);
    matchingPassengers[ride.id] = passengers;
    notifyListeners();
  }

  List<Passenger> getPassengersForRide(Ride ride) {
    return matchingPassengers[ride.id] ?? [];
  }

  Future<void> offerRide(Ride ride, List<Passenger> selectedPassengers) async {
    // Implement your offer logic here (e.g., send to backend)
    // For now, just print or update state
    debugPrint(
      'Offering ride ${ride.id} to passengers: ${selectedPassengers.map((p) => p.name).join(", ")}',
    );
    // Optionally notifyListeners();
  }
}
