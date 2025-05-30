import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/model.dart';

class Activity extends Model {
  final String name;
  final TimeOfDay startTime;
  final String description;
  final Address address;

  Activity({
    required super.id,
    required this.name,
    required this.startTime,
    required this.description,
    required this.address,
  });
}
