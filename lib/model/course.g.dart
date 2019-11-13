// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  return Course(
    title: json['title'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    comment: json['comment'] as String,
  );
}

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'comment': instance.comment,
    };
