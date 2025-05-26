import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/vehicle.dart';

abstract class Driver extends User {
  String get name => '$firstName $lastName';
  Vehicle get vehicle;
}
