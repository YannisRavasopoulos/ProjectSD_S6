// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  capacity: (json['capacity'] as num).toInt(),
);

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'capacity': instance.capacity,
};
