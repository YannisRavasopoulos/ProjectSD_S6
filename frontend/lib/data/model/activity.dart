import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';

class Activity {
  final int id;
  final String name;
  final TimeOfDay startTime;
  final String description;
  final Address address;

  Activity({
    required this.id,
    required this.name,
    required this.startTime,
    required this.description,
    required this.address,
  });
}
