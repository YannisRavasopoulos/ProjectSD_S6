import 'package:frontend/data/model.dart';
import 'package:latlong2/latlong.dart';

abstract class Location implements Model {
  LatLng get coordinates;
}

// import 'package:frontend/data/model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'location.g.dart';

// @JsonSerializable()
// class Location extends Model {
//   final LatLng coordinates;
//   final String name;

//   const Location({
//     required super.id,
//     required this.coordinates,
//     required this.name,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) =>
//       _$LocationFromJson(json);

//   Map<String, dynamic> toJson() => _$LocationToJson(this);

//   factory Location.random() {
//     // TODO
//     return Location(
//       id: DateTime.now().millisecondsSinceEpoch,
//       coordinates: LatLng(
//         37.7749 + (0.1 * (DateTime.now().millisecondsSinceEpoch % 100)),
//         -122.4194 + (0.1 * (DateTime.now().millisecondsSinceEpoch % 100)),
//       ),
//       name: 'Location ${DateTime.now().millisecondsSinceEpoch}',
//     );
//   }
// }
