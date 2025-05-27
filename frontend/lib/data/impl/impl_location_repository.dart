import 'package:frontend/data/model/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/model/user.dart';
import 'dart:math';

class ImplLocation extends Location {
  @override
  final int id;
  @override
  final String name;
  @override
  final LatLng coordinates;

  ImplLocation({
    required this.id,
    required this.name,
    required this.coordinates,
  });

  factory ImplLocation.test(String status) {
    if (status == 'start') {
      return patrasLocations[6]; // University of Patras
    } else if (status == 'end') {
      return patrasLocations[8]; // Georgiou Square
    }
    throw ArgumentError('Invalid location type: $status');
  }
}

// Hardcoded locations for Patras
final List<ImplLocation> patrasLocations = [
  ImplLocation(
    id: 3,
    name: 'Patras Castle',
    coordinates: LatLng(38.246639, 21.734573),
  ),
  ImplLocation(
    id: 4,
    name: 'Saint Andrew Cathedral',
    coordinates: LatLng(38.240486, 21.734222),
  ),
  ImplLocation(
    id: 5,
    name: 'Patras Port',
    coordinates: LatLng(38.243055, 21.728611),
  ),
  ImplLocation(
    id: 6,
    name: 'University of Patras',
    coordinates: LatLng(38.288222, 21.786111),
  ),
  ImplLocation(
    id: 7,
    name: 'Rio Bridge',
    coordinates: LatLng(38.294722, 21.765278),
  ),
  ImplLocation(
    id: 8,
    name: 'Georgiou Square',
    coordinates: LatLng(38.246944, 21.734444),
  ),
];

// Optionally, split into origins and destinations if needed
final List<ImplLocation> originLocations = [
  patrasLocations[0], // Patras Castle
  patrasLocations[1], // Saint Andrew Cathedral
  patrasLocations[2], // Patras Port
];

final List<ImplLocation> destinationLocations = [
  patrasLocations[3], // University of Patras
  patrasLocations[4], // Rio Bridge
  patrasLocations[5], // Georgiou Square
];

// Repository implementation
class ImplLocationRepository implements LocationRepository {
  @override
  Future<Location> fetchCurrent(User user) async {
    // For testing, always return Dummy - Paris
    return ImplLocation.test('start');
  }

  @override
  Stream<Location> watchCurrent(User user) async* {
    // For testing, always yield Patras Castle
    yield originLocations[0];
  }

  @override
  Future<Location> fetchForQuery(String query) async {
    // Simple search by name
    return patrasLocations.firstWhere(
      (loc) => loc.name.toLowerCase().contains(query.toLowerCase()),
      orElse: () => patrasLocations[0],
    );
  }
}
