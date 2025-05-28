import 'package:frontend/data/model/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/model/user.dart';

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
      return originLocations[0];
    } else if (status == 'end') {
      return destinationLocations[0];
    }
    throw ArgumentError('Invalid location type: $status');
  }
}

// Optionally, split into origins and destinations if needed
final List<ImplLocation> originLocations = [
  ImplLocation(
    // 0
    id: 3,
    name: 'Patras Castle',
    coordinates: LatLng(38.246639, 21.734573),
  ),
  ImplLocation(
    // 1
    id: 4,
    name: 'Saint Andrew Cathedral',
    coordinates: LatLng(38.240486, 21.734222),
  ),
  ImplLocation(
    // 2
    id: 5,
    name: 'Patras Port',
    coordinates: LatLng(38.243055, 21.728611),
  ),
];

final List<ImplLocation> destinationLocations = [
  ImplLocation(
    // 0
    id: 6,
    name: 'University of Patras',
    coordinates: LatLng(38.288222, 21.786111),
  ),
  ImplLocation(
    // 1
    id: 7,
    name: 'Rio Bridge',
    coordinates: LatLng(38.294722, 21.765278),
  ),
  ImplLocation(
    // 2
    id: 8,
    name: 'Georgiou Square',
    coordinates: LatLng(38.246944, 21.734444),
  ),
];

final List<ImplLocation> patrasLocations = [
  ...originLocations,
  ...destinationLocations,
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
    return originLocations.firstWhere(
      (loc) => loc.name.toLowerCase().contains(query.toLowerCase()),
      orElse: () => patrasLocations[0],
    );
  }
}
