import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/user.dart';
import 'package:latlong2/latlong.dart';

abstract interface class AddressRepository {
  /// Retrieves a list of addresses which are best described by the specified coordinates (reverse geocoding).
  Future<List<Address>> fetchForCoordinates(LatLng coordinates);

  /// Retrieves a list of addresses which match the specified query (geocoding).
  Future<List<Address>> fetchForQuery(String query);

  ///
  Future<Address> fetchCurrent();

  ///
  Stream<Address> watchCurrent();

  /// Fetches a user's location.
  Future<Address> fetchCurrentOf(User user);

  /// Watches for changes in a user's location.
  Stream<Address> watchCurrentOf(User user);
}
