// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Partner _$PartnerFromJson(Map json) {
  return Partner(
    fcmList: (json['fcmList'] as List)?.map((e) => e as String)?.toList(),
    address: json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map),
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    imgUrl: json['imgUrl'] as String,
    websiteUrl: json['websiteUrl'] as String,
  )
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..phoneNumber = json['phoneNumber'] as String
    ..email = json['email'] as String
    ..currentDogIndex = json['currentDogIndex'] as int
    ..fcm = json['fcm'] as String
    ..appVersion = (json['appVersion'] as num)?.toDouble()
    ..allowsNotifications = json['allowsNotifications'] as bool
    ..notifications = json['notifications'] as int
    ..openingHours = json['openingHours'] == null
        ? null
        : OpeningHours.fromJson((json['openingHours'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

Map<String, dynamic> _$PartnerToJson(Partner instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'currentDogIndex': instance.currentDogIndex,
      'fcm': instance.fcm,
      'appVersion': instance.appVersion,
      'allowsNotifications': instance.allowsNotifications,
      'notifications': instance.notifications,
      'fcmList': instance.fcmList,
      'imgUrl': instance.imgUrl,
      'websiteUrl': instance.websiteUrl,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'openingHours': instance.openingHours,
    };
