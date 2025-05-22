// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
  id: (json['id'] as num).toInt(),
  driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
  passengers:
      (json['passengers'] as List<dynamic>)
          .map((e) => Passenger.fromJson(e as Map<String, dynamic>))
          .toList(),
  departureTime: DateTime.parse(json['departureTime'] as String),
);

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
  'id': instance.id,
  'driver': instance.driver,
  'passengers': instance.passengers,
  'departureTime': instance.departureTime.toIso8601String(),
};
