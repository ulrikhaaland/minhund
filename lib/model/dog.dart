import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/model/course.dart';
import 'package:minhund/model/veterinary_visit.dart';

part 'dog.g.dart';

@JsonSerializable()
class Dog {
  Dog({
    this.name,
    this.weigth,
    this.birthDate,
    this.race,
    this.veterinaryVisits,
    this.courses,
    this.address,
    this.chipNumber,
    this.id,
  });
  String id;
  String name;
  String weigth;
  String chipNumber;
  Address address;
  DateTime birthDate;
  String race;
  List<VeterinaryVisit> veterinaryVisits;
  List<Course> courses;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);

  Map<String, dynamic> toJson() => _$DogToJson(this);
}
