import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_offer.g.dart';

@JsonSerializable()
class PartnerOffer {
  PartnerOffer(
      {this.title,
      this.desc,
      this.price,
      this.imgUrl,
      this.endOfOffer,
      this.id});
  String id;
  String title;
  double price;
  String desc;
  String imgUrl;
  DateTime endOfOffer;
  bool active;
  @JsonKey(ignore: true)
  DocumentReference docRef;
  @JsonKey(ignore: true)
  File imageFile;
  bool inMarket;

  factory PartnerOffer.fromJson(Map<String, dynamic> json) =>
      _$PartnerOfferFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerOfferToJson(this);
}
