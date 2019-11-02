import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/partner/partner-reservation/partner_reservation.dart';

part 'partner_offer.g.dart';

@JsonSerializable(anyMap: true)
class PartnerOffer {
  PartnerOffer(
      {this.title,
      this.desc,
      this.price,
      this.imgUrl,
      this.endOfOffer,
      this.partnerId,
      this.partnerReservation,
      this.id});
  String id;
  String partnerId;
  DateTime createdAt;
  String title;
  double price;
  String desc;
  int sortIndex;
  String imgUrl;
  DateTime endOfOffer;
  bool active;
  String type;
  @JsonKey(ignore: true)
  DocumentReference docRef;
  @JsonKey(ignore: true)
  File imageFile;
  // @JsonKey(toJson: partnerToJson )
  PartnerReservation partnerReservation;
  bool inMarket;

//  PartnerReservation partnerToJson() =>  PartnerReservation.toJson();

  factory PartnerOffer.fromJson(Map<String, dynamic> json) =>
      _$PartnerOfferFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerOfferToJson(this);
}
