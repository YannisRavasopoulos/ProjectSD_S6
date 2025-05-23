import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/offer_ride_repository.dart';

class OfferRideViewModel extends ChangeNotifier {
  final OfferRideRepository offerRideRepository;

  OfferRideViewModel({required this.offerRideRepository});

  List<Ride> get createdRides => offerRideRepository.getCreatedRides();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addRide(Ride ride) {
    offerRideRepository.addRide(ride);
    notifyListeners();
  }

  void removeRide(int id) {
    offerRideRepository.removeRide(id);
    notifyListeners();
  }

  // Dummy function for demo
  Future<List<String>> findNearbyCarpoolers(String rideId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ride = createdRides.firstWhere((r) => r.id.toString() == rideId);
    if (ride == null) return [];
    // Επιστρέφει τόσα ονόματα όσοι οι διαθέσιμες θέσεις
    return List.generate(ride.availableSeats, (i) => 'Carpooler ${i + 1}');
  }
}
