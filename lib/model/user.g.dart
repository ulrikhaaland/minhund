// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    id: json['id'] as String,
    fcm: json['fcm'] as String,
    appVersion: (json['appVersion'] as num)?.toDouble(),
    notifications: json['notifications'] as int,
    name: json['name'] as String,
    dogs: (json['dogs'] as List)
        ?.map((e) => e == null ? null : Dog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    phoneNumber: json['phoneNumber'] as String,
    address: json['address'] as String,
    city: json['city'] as String,
    county: json['county'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'city': instance.city,
      'county': instance.county,
      'address': instance.address,
      'fcm': instance.fcm,
      'appVersion': instance.appVersion,
      'notifications': instance.notifications,
      'dogs': instance.dogs,
    };
