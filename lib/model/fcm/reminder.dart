import 'package:json_annotation/json_annotation.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  Reminder(
      {this.eventId,
      this.title,
      this.body,
      this.timestamp,
      this.userId,
      this.note});
  String eventId;
  String title;
  String body;
  String userId;
  String note;
  String timestampAsIso;
  DateTime timestamp;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
