import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/place.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/data/model/user.dart';

// Repository implementation
class ImplAddressRepository implements AddressRepository {
  @override
  Future<Address> fetchCurrentOf(User user) async {
    return places[0].address;
  }

  @override
  Stream<Address> watchCurrentOf(User user) async* {
    // TODO
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield places[0].address;
    }
  }

  @override
  Future<List<Address>> fetchForQuery(String query) async {
    // Simple search by name match
    var results =
        places
            .where(
              (place) => place.name.toLowerCase().contains(query.toLowerCase()),
            )
            .map((place) => place.address)
            .toList();

    print("===");
    print(query);
    print(results);
    print("===");
    return results;
  }

  int _distance(LatLng p1, LatLng p2) {
    final d = Distance();
    return d.as(LengthUnit.Meter, p1, p2).round();
  }

  @override
  Future<List<Address>> fetchForCoordinates(LatLng coordinates) async {
    var closePlaces =
        places
            .where(
              (place) =>
                  _distance(place.address.coordinates, coordinates) <
                  1000, // within 1km
            )
            .map((place) => place.address)
            .toList();

    // Sort places by distance to the given coordinates
    closePlaces.sort(
      (a, b) => _distance(
        a.coordinates,
        coordinates,
      ).compareTo(_distance(b.coordinates, coordinates)),
    );

    return closePlaces;
  }

  @override
  Future<Address> fetchCurrent() async {
    // For simplicity, return the first place's address
    return places[0].address;
  }

  @override
  Stream<Address> watchCurrent() async* {
    // TODO
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield places[0].address;
    }
  }
}
