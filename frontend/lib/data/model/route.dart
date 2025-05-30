import 'package:frontend/data/model/address.dart';
import 'package:latlong2/latlong.dart';

class Route {
  final Address start;
  final Address end;

  Route({required this.start, required this.end});

  // Hardcoded routes using addresses from ImplAddressRepository._places
  static final List<Route> routes = [
    // Apollon Theatre -> Georgiou I Square
    Route(
      start: Address(
        coordinates: LatLng(38.246630, 21.735500),
        city: 'Patras',
        street: 'Othonos-Amalias Avenue',
        number: 6,
        postalCode: '',
      ),
      end: Address(
        coordinates: LatLng(38.246200, 21.735100),
        city: 'Patras',
        street: 'Maizonos Street',
        number: 0,
        postalCode: '',
      ),
    ),
    // Patras Castle -> Patras Lighthouse
    Route(
      start: Address(
        coordinates: LatLng(38.245000, 21.741800),
        city: 'Patras',
        street: 'Near Panachaiko Mountain',
        number: 0,
        postalCode: '',
      ),
      end: Address(
        coordinates: LatLng(38.245120, 21.725690),
        city: 'Patras',
        street: 'Trion Navarchon Street',
        number: 0,
        postalCode: '',
      ),
    ),
    // Archaeological Museum of Patras -> Pampeloponnisiako Stadium
    Route(
      start: Address(
        coordinates: LatLng(38.263344, 21.752354),
        city: 'Patras',
        street: 'Amerikis Street & Patras-Athens National Road',
        number: 38,
        postalCode: '',
      ),
      end: Address(
        coordinates: LatLng(38.221806, 21.752189),
        city: 'Patras',
        street: 'Patron-Klaous Street',
        number: 91,
        postalCode: '',
      ),
    ),
    // City Hall of Patras -> Patras Land Registry
    Route(
      start: Address(
        coordinates: LatLng(38.245480, 21.733240),
        city: 'Patras',
        street: 'Maizonos Street',
        number: 108,
        postalCode: '',
      ),
      end: Address(
        coordinates: LatLng(38.244640, 21.730690),
        city: 'Patras',
        street: 'Miaouli Street',
        number: 19,
        postalCode: '',
      ),
    ),
    // Ethnikis Antistaseos Square -> Kostas Davourlis Stadium
    Route(
      start: Address(
        coordinates: LatLng(38.249200, 21.737500),
        city: 'Patras',
        street:
            'Intersection of Aratou, Maizonos, Kolokotroni, and Riga Feraiou Streets',
        number: 0,
        postalCode: '',
      ),
      end: Address(
        coordinates: LatLng(38.261700, 21.745800),
        city: 'Patras',
        street: 'Agyia Area',
        number: 0,
        postalCode: '',
      ),
    ),
  ];
}
