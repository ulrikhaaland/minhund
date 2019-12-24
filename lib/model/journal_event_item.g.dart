// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEventItem _$JournalEventItemFromJson(Map<String, dynamic> json) {
  return JournalEventItem(
      title: json['title'] as String,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
      note: json['note'] as String,
      id: json['id'] as String,
      categoryId: json['id'] as String,
      reminder: json['reminder'] == null
          ? null
          : DateTime.parse(json['reminder'] as String),
      reminderString: json['reminderString'] as String,
      colorIndex: json['colorIndex'] as int,
      sortIndex: json['sortIndex'] as int,
      completed: json['completed'] as bool);
}

Map<String, dynamic> _$JournalEventItemToJson(JournalEventItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'reminder': instance.reminder?.toIso8601String(),
      'reminderString': instance.reminderString,
      'note': instance.note,
      'categoryId': instance.categoryId,
      'completed': instance.completed,
      'colorIndex': instance.colorIndex,
      'sortIndex': instance.sortIndex,
    };
