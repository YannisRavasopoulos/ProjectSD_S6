import 'package:frontend/data/model.dart';

abstract interface class Address implements Model {
  String get city;
  String get street;
  int get number;
  String get postalCode;
}
