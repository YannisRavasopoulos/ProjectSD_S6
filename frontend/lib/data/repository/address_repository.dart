import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/user.dart';
import 'package:latlong2/latlong.dart';

abstract interface class AddressRepository {
  Future<List<Address>> fetchForCoordinates(LatLng coordinates);
  Future<List<Address>> fetchForQuery(String query);

  /// Fetches a user's location.
  Future<Address> fetchCurrent(User user);

  /// Watches for changes in a user's location.
  Stream<Address> watchCurrent(User user);
}
