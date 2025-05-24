import 'package:frontend/data/model/ride.dart';

class OfferRideRepository {
  final List<Ride> _createdRides = [];

  List<Ride> getCreatedRides() => List.unmodifiable(_createdRides);

  void addRide(Ride ride) {
    if (!_createdRides.any((r) => r.id == ride.id)) {
      _createdRides.add(ride);
    }
  }

  void removeRide(int id) {
    _createdRides.removeWhere((r) => r.id == id);
  }
}
