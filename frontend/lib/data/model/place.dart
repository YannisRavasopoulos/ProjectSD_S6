import 'package:frontend/data/model/address.dart';
import 'package:latlong2/latlong.dart';

class Place {
  final String name;
  final Address address;

  Place({required this.name, required this.address});
}

final List<Place> places = [
  Place(
    name: 'Apollon Theatre',
    address: Address(
      id: 1,
      coordinates: LatLng(38.246630, 21.735500),
      city: 'Patras',
      street: 'Othonos-Amalias Avenue',
      number: 6,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Georgiou I Square',
    address: Address(
      id: 2,
      coordinates: LatLng(38.246200, 21.735100),
      city: 'Patras',
      street: 'Maizonos Street',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Patras Castle',
    address: Address(
      id: 3,
      coordinates: LatLng(38.245000, 21.741800),
      city: 'Patras',
      street: 'Near Panachaiko Mountain',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Patras Lighthouse',
    address: Address(
      id: 4,
      coordinates: LatLng(38.245120, 21.725690),
      city: 'Patras',
      street: 'Trion Navarchon Street',
      number: 0,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Archaeological Museum of Patras',
    address: Address(
      id: 5,
      coordinates: LatLng(38.263344, 21.752354),
      city: 'Patras',
      street: 'Amerikis Street & Patras-Athens National Road',
      number: 38,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Pampeloponnisiako Stadium',
    address: Address(
      id: 6,
      coordinates: LatLng(38.221806, 21.752189),
      city: 'Patras',
      street: 'Patron-Klaous Street',
      number: 91,
      postalCode: '',
    ),
  ),
  Place(
    name: 'City Hall of Patras',
    address: Address(
      id: 7,
      coordinates: LatLng(38.245480, 21.733240),
      city: 'Patras',
      street: 'Maizonos Street',
      number: 108,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Patras Land Registry',
    address: Address(
      id: 8,
      coordinates: LatLng(38.244640, 21.730690),
      city: 'Patras',
      street: 'Miaouli Street',
      number: 19,
      postalCode: '',
    ),
  ),
  Place(
    name: 'Ethnikis Antistaseos Square',
    address: Address(
      id: 9,
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
    address: Address(
      id: 10,
      coordinates: LatLng(38.261700, 21.745800),
      city: 'Patras',
      street: 'Agyia Area',
      number: 0,
      postalCode: '',
    ),
  ),
];
