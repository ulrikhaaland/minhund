// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opening_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return OpeningHours(
    dayFrom: json['dayFrom'] == null
        ? null
        : DateTime.parse(json['dayFrom'] as String),
    dayTo:
        json['dayTo'] == null ? null : DateTime.parse(json['dayTo'] as String),
    weekendFrom: json['weekendFrom'] == null
        ? null
        : DateTime.parse(json['weekendFrom'] as String),
    weekendTo: json['weekendTo'] == null
        ? null
        : DateTime.parse(json['weekendTo'] as String),
  )..comment = json['comment'] as String;
}

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'dayFrom': instance.dayFrom?.toIso8601String(),
      'dayTo': instance.dayTo?.toIso8601String(),
      'weekendFrom': instance.weekendFrom?.toIso8601String(),
      'weekendTo': instance.weekendTo?.toIso8601String(),
      'comment': instance.comment,
    };
