// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return Reminder(
    eventId: json['eventId'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    userId: json['userId'] as String,
    note: json['note'] as String,
  );
}

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'eventId': instance.eventId,
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
      'note': instance.note,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
