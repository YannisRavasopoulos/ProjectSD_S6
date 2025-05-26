import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/address_repository.dart';

// import 'package:frontend/data/location_exception.dart';
// import 'package:frontend/data/model/location.dart';
// import 'package:geocode/geocode.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';

// class LocationRepository {
//   GeoCode _geoCodeApi = GeoCode();

//   // Watch for changes in current location
//   Stream<Location> watchCurrent() async* {
//     while (true) {
//       // Update every 5 seconds
//       yield await fetchCurrent();
//       await Future.delayed(const Duration(seconds: 5));
//     }
//   }

//   Future<Location> fetchForCoordinates(LatLng coordinates) async {
//     var address = await _geoCodeApi.reverseGeocoding(
//       latitude: coordinates.latitude,
//       longitude: coordinates.longitude,
//     );

//     return Location(id: 1, coordinates: coordinates, name: address.toString());
//   }

//   Future<Location> fetchCurrent() async {
//     var isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isServiceEnabled) {
//       throw LocationException('Location services are disabled.');
//     }

//     // We must first get permission from the user

//     var permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw LocationException('Location permissions denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw LocationException('Location permissions permanently denied.');
//     }

//     var position = await Geolocator.getCurrentPosition();
//     var location = await fetchForCoordinates(
//       LatLng(position.latitude, position.longitude),
//     );

//     return location;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoHelper {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  static const Map<String, String> _headers = {
    'User-Agent': 'YourAppName (your@email.com)',
  };

  /// Geocoding: Address → Coordinates
  static Future<List<Map<String, dynamic>>> geocode(String address) async {
    final uri = Uri.parse(
      '$_baseUrl/search?q=$address&format=json&limit=3&countrycodes=gr&addressdetails=1',
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map<Map<String, dynamic>>(
            (e) => {
              'id': e['place_id'],
              'latitude': double.parse(e['lat']),
              'longitude': double.parse(e['lon']),
              'name': e['display_name'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  /// Reverse Geocoding: Coordinates → Address
  static Future<String> reverseGeocode(double lat, double lon) async {
    final uri = Uri.parse(
      '$_baseUrl/reverse?format=jsonv2&lat=$lat&lon=$lon&countrycodes=gr&addressdetails=1',
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data['display_name'] ?? 'No address found';
    } else {
      throw Exception('Failed to fetch address');
    }
  }
}

class AddressImpl implements Address {
  @override
  final String city;

  @override
  final String street;

  @override
  final int number;

  @override
  final String postalCode;

  @override
  final int id;

  AddressImpl({
    required this.city,
    required this.street,
    required this.number,
    required this.postalCode,
    required this.id,
  });
}

class AddressRepositoryImpl implements AddressRepository {
  // @override
  Future<Address> fetchForLocation(Location location) async {
    // var address = await GeoHelper.reverseGeocode(
    //   location.coordinates.latitude,
    //   location.coordinates.longitude,
    // );

    // print(address);

    // return AddressImpl(
    //   id: location.id,
    //   city: 'City Placeholder', // Extract city from address if available
    //   street: 'Street Placeholder', // Extract street from address if available
    //   number: 0, // Extract number from address if available
    //   postalCode: "",
    // );
  }

  @override
  Future<List<Address>> fetchForQuery(String query) async {
    // var results = await GeoHelper.geocode(query);

    // print(results);

    // return results.map((result) {
    //   var s = (result['name'] as String).split(',');
    //   var city = s[0].trim();
    //   var street = s[1].trim();
    //   var number = int.tryParse(s[2].trim()) ?? -1;
    //   var postalCode = s[8].trim();

    //   // print('Parsed address: $city, $street, $number, $postalCode');

    //   return AddressImpl(
    //     id: result['id'],
    //     city: city,
    //     street: street,
    //     number: number,
    //     postalCode: postalCode,
    //   );
    // }).toList();
  }
}
