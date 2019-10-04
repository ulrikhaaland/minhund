import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_event_item.g.dart';

@JsonSerializable()
class JournalEventItem {
  JournalEventItem({this.title, this.timeStamp, this.note, this.reminder});

  String title;
  DateTime timeStamp;
  DateTime reminder;
  String note;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory JournalEventItem.fromJson(Map<String, dynamic> json) =>
      _$JournalEventItemFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEventItemToJson(this);
}
