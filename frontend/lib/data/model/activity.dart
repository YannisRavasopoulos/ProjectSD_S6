// import 'package:flutter/material.dart';
// import 'package:frontend/data/model.dart';
// import 'package:frontend/data/model/location.dart';
// import 'package:frontend/data/time_of_day_json_converter.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'activity.g.dart';

// @JsonSerializable()
// class Activity extends Model {
//   final String name;
//   final Location location;

//   @TimeOfDayJsonConverter()
//   final TimeOfDay time;

//   Activity({
//     required super.id,
//     required this.name,
//     required this.location,
//     required this.time,
//   });

//   factory Activity.fromJson(Map<String, dynamic> json) =>
//       _$ActivityFromJson(json);

//   Map<String, dynamic> toJson() => _$ActivityToJson(this);

//   factory Activity.random() {
//     return Activity(
//       id: DateTime.now().millisecondsSinceEpoch,
//       name: 'Activity ${DateTime.now().millisecondsSinceEpoch}',
//       location: Location.random(),
//       time: TimeOfDay.now(),
//     );
//   }
// }
