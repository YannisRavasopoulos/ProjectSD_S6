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
      coordinates: LatLng(38.261700, 21.745800),
      city: 'Patras',
      street: 'Agyia Area',
      number: 0,
      postalCode: '',
    );
  }

  @override
  String toString() {
    return '$street $number, $city, $postalCode';
  }
}
