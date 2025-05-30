import 'package:frontend/data/model/model.dart';
import 'package:latlong2/latlong.dart';

class Address extends Model {
  final LatLng coordinates;
  final String city;
  final String street;
  final int number;
  final String postalCode;

  Address({
    required super.id,
    required this.coordinates,
    required this.city,
    required this.street,
    required this.number,
    required this.postalCode,
  });

  factory Address.fake() {
    return Address(
      id: 1,
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
