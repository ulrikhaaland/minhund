import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/journal_event_item.dart';

part 'journal_item.g.dart';

@JsonSerializable()
class JournalItem {
  JournalItem({this.title, this.journalEventItems, this.sortIndex});

  String id;
  String title;
  @JsonKey(ignore: true)
  List<JournalEventItem> journalEventItems;
  int sortIndex;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory JournalItem.fromJson(Map<String, dynamic> json) =>
      _$JournalItemFromJson(json);

  Map<String, dynamic> toJson() => _$JournalItemToJson(this);
}
