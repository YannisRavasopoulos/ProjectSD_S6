import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/location.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Route extends Model {
  final Location start;
  final Location end;

  const Route({required super.id, required this.start, required this.end});
}
