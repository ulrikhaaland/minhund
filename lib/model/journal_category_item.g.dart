// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_category_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalCategoryItem _$JournalCategoryItemFromJson(Map<String, dynamic> json) {
  return JournalCategoryItem(
    title: json['title'] as String,
    sortIndex: json['sortIndex'] as int,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$JournalCategoryItemToJson(
        JournalCategoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sortIndex': instance.sortIndex,
    };
