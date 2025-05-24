import 'package:flutter/material.dart';
import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/location.dart';

abstract class Activity implements Model {
  /// The name of the activity.
  String get name;

  /// The location where the activity takes place.
  Location get location;

  /// The time of day when the activity occurs.
  TimeOfDay get time;
}
