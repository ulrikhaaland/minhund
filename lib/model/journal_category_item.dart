import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/journal_event_item.dart';

part 'journal_category_item.g.dart';

@JsonSerializable()
class JournalCategoryItem {
  JournalCategoryItem({this.title, this.journalEventItems, this.sortIndex});

  String id;
  String title;
  @JsonKey(ignore: true)
  List<JournalEventItem> journalEventItems;
  int sortIndex;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory JournalCategoryItem.fromJson(Map<String, dynamic> json) =>
      _$JournalCategoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$JournalCategoryItemToJson(this);
}
