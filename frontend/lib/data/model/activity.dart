import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/location.dart';

class Activity {
  final int id;
  final String name;
  final Location location;
  final TimeOfDay time;

  Activity({
    required this.id,
    required this.name,
    required this.location,
    required this.time,
  });

  Activity.random()
    : id = DateTime.now().millisecondsSinceEpoch,
      name =
          ['University', 'Gym', 'Work', 'Grocery Store', 'Errands'][Random()
              .nextInt(4)],
      location = Location.random(),
      time = TimeOfDay.now();
}
