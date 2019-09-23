import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
      {this.email,
      this.id,
      this.userName,
      this.fcm,
      this.bio,
      this.imageUrl,
      this.appVersion,
      this.notifications,
      this.blockedUserIds,
      this.bookmarkIds,
      this.docRef,
      this.rating,
      this.userNameId});

  String userName;
  String userNameId;
  String id;
  String email;
  String fcm;
  String bio;
  String imageUrl;
  double appVersion;
  int notifications;
  double rating;
  DateTime birthDate;
  List<String> blockedUserIds;
  @JsonKey(ignore: true)
  bool blocked;
  @JsonKey(ignore: true)
  Widget profileImageWidget;
  List<String> bookmarkIds;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
