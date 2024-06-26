import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/partner/partner-reservation/partner_reservation.dart';
import 'package:minhund/model/partner/partner.dart';

part 'offer.g.dart';

@JsonSerializable(anyMap: true)
class Offer {
  Offer(
      {this.title,
      this.desc,
      this.price,
      this.imgUrl,
      this.endOfOffer,
      this.partnerReservation,
      this.id,
      this.partnerId,
      this.createdAt,
      this.type});
  String id;
  DateTime createdAt;
  String title;
  double price;
  Partner partner;
  String desc;
  String imgUrl;
  DateTime endOfOffer;
  String type;
  String partnerId;
  @JsonKey(ignore: true)
  DocumentReference docRef;
  PartnerReservation partnerReservation;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
