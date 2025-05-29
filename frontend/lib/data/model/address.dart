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

  factory Address.fake() {
    return Address(
      coordinates: LatLng(0, 0),
      city: 'Fake City',
      street: 'Fake Street',
      number: 123,
      postalCode: '00000',
    );
  }

  @override
  String toString() {
    return '$street $number, $city, $postalCode';
  }
}
