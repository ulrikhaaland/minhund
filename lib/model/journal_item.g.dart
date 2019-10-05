// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalItem _$JournalItemFromJson(Map<String, dynamic> json) {
  return JournalItem(
    title: json['title'] as String,
    sortIndex: json['sortIndex'] as int,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$JournalItemToJson(JournalItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sortIndex': instance.sortIndex,
    };
