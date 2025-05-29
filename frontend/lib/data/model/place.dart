import 'package:latlong2/latlong.dart';

class Place {
  final String name;
  final String description;
  final Address address;

  Place({required this.name, required this.description, required this.address});
}

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

final List<Place> places = [
  Place(
    name: 'Apollon Theatre',
    description: '',
    address: Address(
      coordinates: LatLng(38.246630, 21.735500),
      city: 'Patras',
      street: 'Othonos-Amalias Avenue',
      number: 6,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Georgiou I Square',
    description: '',
    address: Address(
      coordinates: LatLng(38.246200, 21.735100),
      city: 'Patras',
      street: 'Maizonos Street',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Patras Castle',
    description: '',
    address: Address(
      coordinates: LatLng(38.245000, 21.741800),
      city: 'Patras',
      street: 'Near Panachaiko Mountain',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Patras Lighthouse',
    description: '',
    address: Address(
      coordinates: LatLng(38.245120, 21.725690),
      city: 'Patras',
      street: 'Trion Navarchon Street',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Archaeological Museum of Patras',
    description: '',
    address: Address(
      coordinates: LatLng(38.263344, 21.752354),
      city: 'Patras',
      street: 'Amerikis Street & Patras-Athens National Road',
      number: 38,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Pampeloponnisiako Stadium',
    description: '',
    address: Address(
      coordinates: LatLng(38.221806, 21.752189),
      city: 'Patras',
      street: 'Patron-Klaous Street',
      number: 91,
      postalCode: '',
    ),
  ),
  Place(
    name: 'City Hall of Patras',
    description: '',
    address: Address(
      coordinates: LatLng(38.245480, 21.733240),
      city: 'Patras',
      street: 'Maizonos Street',
      number: 108,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Patras Land Registry',
    description: '',
    address: Address(
      coordinates: LatLng(38.244640, 21.730690),
      city: 'Patras',
      street: 'Miaouli Street',
      number: 19,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Ethnikis Antistaseos Square',
    description: '',
    address: Address(
      coordinates: LatLng(38.249200, 21.737500),
      city: 'Patras',
      street:
          'Intersection of Aratou, Maizonos, Kolokotroni, and Riga Feraiou Streets',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Kostas Davourlis Stadium',
    description: '',
    address: Address(
      coordinates: LatLng(38.261700, 21.745800),
      city: 'Patras',
      street: 'Agyia Area',
      number: 0,
      postalCode: '',
    ),
  ),
];
