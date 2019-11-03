import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/partner/partner-reservation/partner_reservation.dart';

part 'offer.g.dart';

@JsonSerializable(anyMap: true)
class Offer {
  Offer(
      {this.title,
      this.desc,
      this.price,
      this.imgUrl,
      this.endOfOffer,
      this.partnerId,
      this.partnerReservation,
      this.id,
      this.createdAt,
      this.type});
  String id;
  String partnerId;
  DateTime createdAt;
  String title;
  double price;
  String desc;
  String imgUrl;
  DateTime endOfOffer;
  String type;
  @JsonKey(ignore: true)
  DocumentReference docRef;
  PartnerReservation partnerReservation;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
