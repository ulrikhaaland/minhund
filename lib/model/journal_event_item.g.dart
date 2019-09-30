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
  );
}

Map<String, dynamic> _$JournalEventItemToJson(JournalEventItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'note': instance.note,
    };
