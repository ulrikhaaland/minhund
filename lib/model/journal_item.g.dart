// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalItem _$JournalItemFromJson(Map<String, dynamic> json) {
  return JournalItem(
    title: json['title'] as String,
    journalEventItems: (json['journalEventItems'] as List)
        ?.map((e) => e == null
            ? null
            : JournalEventItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sortIndex: json['sortIndex'] as int,
  );
}

Map<String, dynamic> _$JournalItemToJson(JournalItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'journalEventItems': instance.journalEventItems,
      'sortIndex': instance.sortIndex,
    };
