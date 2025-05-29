import 'package:latlong2/latlong.dart';

class Address {
  final LatLng coordinates;
  final String city;
  final String street;
  final int number;
  final String postalCode;

  Address({
    required this.coordinates,
    required this.city,
    required this.street,
    required this.number,
    required this.postalCode,
  });
}
