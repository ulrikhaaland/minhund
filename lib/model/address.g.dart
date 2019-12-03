// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map json) {
  return Address(
    address: json['address'] as String,
    city: json['city'] as String,
    county: json['county'] as String,
    zip: json['zip'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'city': instance.city,
      'zip': instance.zip,
      'county': instance.county,
      'address': instance.address,
    };
