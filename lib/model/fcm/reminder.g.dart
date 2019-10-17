// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return Reminder(
    title: json['title'] as String,
    body: json['body'] as String,
    fcm: json['fcm'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'fcm': instance.fcm,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
