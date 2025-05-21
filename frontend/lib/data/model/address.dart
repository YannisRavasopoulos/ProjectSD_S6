import 'package:frontend/data/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends Model {
  final String city;
  final String street;
  final int number;
  final String postalCode;

  const Address({
    required super.id,
    required this.city,
    required this.street,
    required this.number,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
