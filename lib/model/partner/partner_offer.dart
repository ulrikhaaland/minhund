import 'package:json_annotation/json_annotation.dart';

part 'partner_offer.g.dart';

@JsonSerializable()
class PartnerOffer {
  PartnerOffer(
      {this.title, this.desc, this.price, this.imgUrl, this.endOfOffer});
  String title;
  double price;
  String desc;
  String imgUrl;
  DateTime endOfOffer;
  bool active;

  factory PartnerOffer.fromJson(Map<String, dynamic> json) =>
      _$PartnerOfferFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerOfferToJson(this);
}
