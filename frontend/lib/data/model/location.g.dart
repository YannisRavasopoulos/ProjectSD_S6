// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  id: (json['id'] as num).toInt(),
  coordinates: LatLng.fromJson(json['coordinates'] as Map<String, dynamic>),
  name: json['name'] as String,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'id': instance.id,
  'coordinates': instance.coordinates,
  'name': instance.name,
};
