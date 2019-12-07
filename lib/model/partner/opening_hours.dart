import 'package:json_annotation/json_annotation.dart';

part 'opening_hours.g.dart';

@JsonSerializable()
class OpeningHours {
  OpeningHours({this.dayFrom, this.dayTo, this.weekendFrom, this.weekendTo});
  DateTime dayFrom;
  DateTime dayTo;
  DateTime weekendFrom;
  DateTime weekendTo;
  String comment;

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}
