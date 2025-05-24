import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/location.dart';

abstract class Route implements Model {
  Location get start;
  Location get end;
}
