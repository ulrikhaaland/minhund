// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veterinary_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VeterinaryVisit _$VeterinaryVisitFromJson(Map<String, dynamic> json) {
  return VeterinaryVisit(
    title: json['title'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    comment: json['comment'] as String,
  );
}

Map<String, dynamic> _$VeterinaryVisitToJson(VeterinaryVisit instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'comment': instance.comment,
    };
