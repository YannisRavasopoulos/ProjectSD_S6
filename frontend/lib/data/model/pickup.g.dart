// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pickup _$PickupFromJson(Map<String, dynamic> json) => Pickup(
  id: (json['id'] as num).toInt(),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  status: $enumDecode(_$PickupStatusEnumMap, json['status']),
  driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
  passenger: Passenger.fromJson(json['passenger'] as Map<String, dynamic>),
  ride: Ride.fromJson(json['ride'] as Map<String, dynamic>),
  time: DateTime.parse(json['time'] as String),
);

Map<String, dynamic> _$PickupToJson(Pickup instance) => <String, dynamic>{
  'id': instance.id,
  'driver': instance.driver,
  'passenger': instance.passenger,
  'ride': instance.ride,
  'time': instance.time.toIso8601String(),
  'location': instance.location,
  'status': _$PickupStatusEnumMap[instance.status]!,
};

const _$PickupStatusEnumMap = {
  PickupStatus.pending: 'pending',
  PickupStatus.accepted: 'accepted',
  PickupStatus.completed: 'completed',
  PickupStatus.cancelled: 'cancelled',
};
