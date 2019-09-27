import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dog.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.email,
    this.id,
    this.fcm,
    this.appVersion,
    this.notifications,
    this.docRef,
    this.name,
    this.dogs,
    this.phoneNumber,
    this.address,
    this.city,
    this.county,
  });

  String id;
  String name;
  String phoneNumber;
  String email;
  String city;
  String county;
  String address;
  String fcm;
  double appVersion;
  int notifications;
  List<Dog> dogs;

  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
