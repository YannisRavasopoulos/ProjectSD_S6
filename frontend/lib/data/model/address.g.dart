// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  id: (json['id'] as num).toInt(),
  city: json['city'] as String,
  street: json['street'] as String,
  number: (json['number'] as num).toInt(),
  postalCode: json['postalCode'] as String,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'city': instance.city,
  'street': instance.street,
  'number': instance.number,
  'postalCode': instance.postalCode,
};
