// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  code: json['code'] as String,
  points: (json['points'] as num).toInt(),
);

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'code': instance.code,
  'points': instance.points,
};
