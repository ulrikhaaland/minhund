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
    phoneNumber: json['phoneNumber'] as String,
    currentDogIndex: json['currentDogIndex'] as int,
    allowsNotifications: json['allowsNotifications'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'currentDogIndex': instance.currentDogIndex,
      'fcm': instance.fcm,
      'appVersion': instance.appVersion,
      'allowsNotifications': instance.allowsNotifications,
      'notifications': instance.notifications,
    };
