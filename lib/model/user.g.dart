// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    id: json['id'] as String,
    userName: json['userName'] as String,
    fcm: json['fcm'] as String,
    bio: json['bio'] as String,
    imageUrl: json['imageUrl'] as String,
    appVersion: (json['appVersion'] as num)?.toDouble(),
    notifications: json['notifications'] as int,
    blockedUserIds:
        (json['blockedUserIds'] as List)?.map((e) => e as String)?.toList(),
    bookmarkIds:
        (json['bookmarkIds'] as List)?.map((e) => e as String)?.toList(),
    rating: (json['rating'] as num)?.toDouble(),
    userNameId: json['userNameId'] as String,
  )..birthDate = json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userName': instance.userName,
      'userNameId': instance.userNameId,
      'id': instance.id,
      'email': instance.email,
      'fcm': instance.fcm,
      'bio': instance.bio,
      'imageUrl': instance.imageUrl,
      'appVersion': instance.appVersion,
      'notifications': instance.notifications,
      'rating': instance.rating,
      'birthDate': instance.birthDate?.toIso8601String(),
      'blockedUserIds': instance.blockedUserIds,
      'bookmarkIds': instance.bookmarkIds,
    };
