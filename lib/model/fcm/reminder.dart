import 'package:json_annotation/json_annotation.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  Reminder({this.title, this.body, this.fcm, this.timestamp});
  String title;
  String body;
  String fcm;
  DateTime timestamp;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
