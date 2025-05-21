// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  time: const TimeOfDayJsonConverter().fromJson(json['time'] as String),
);

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'time': const TimeOfDayJsonConverter().toJson(instance.time),
};
