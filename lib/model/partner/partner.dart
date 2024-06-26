import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/model/partner/opening_hours.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/model/user.dart';

part 'partner.g.dart';

@JsonSerializable(anyMap: true)
class Partner extends User {
  Partner({
    this.fcmList,
    this.address,
    this.latitude,
    this.longitude,
    this.imgUrl,
    this.websiteUrl,
    this.offers,
    this.phoneNumber,
  });

  List<String> fcmList;
  String imgUrl;
  String websiteUrl;
  String phoneNumber;
  Address address;
  double latitude;
  double longitude;
  OpeningHours openingHours;
  @JsonKey(ignore: true)
  List<PartnerOffer> offers;

  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerToJson(this);
}
