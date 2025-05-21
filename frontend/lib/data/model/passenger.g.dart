// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Passenger _$PassengerFromJson(Map<String, dynamic> json) => Passenger(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  points: (json['points'] as num).toInt(),
  pickup:
      json['pickup'] == null
          ? null
          : Pickup.fromJson(json['pickup'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'points': instance.points,
  'pickup': instance.pickup,
};
