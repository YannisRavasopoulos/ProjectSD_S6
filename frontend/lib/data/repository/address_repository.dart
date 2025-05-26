import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/location.dart';

abstract interface class AddressRepository {
  Future<Address> fetchForLocation(Location location);

  Future<List<Address>> fetchForQuery(String query);
}
