import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'veterinary_visit.g.dart';

@JsonSerializable()
class VeterinaryVisit {
  VeterinaryVisit({this.title, this.date, this.comment});
  String title;
  DateTime date;
  String comment;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory VeterinaryVisit.fromJson(Map<String, dynamic> json) =>
      _$VeterinaryVisitFromJson(json);

  Map<String, dynamic> toJson() => _$VeterinaryVisitToJson(this);
}
