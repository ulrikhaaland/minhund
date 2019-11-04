import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/partner/partner-reservation/partner_reservation.dart';
import 'package:minhund/model/partner/partner.dart';

import '../offer.dart';

part 'partner_offer.g.dart';

@JsonSerializable(anyMap: true)
class PartnerOffer extends Offer {
  PartnerOffer({
    this.active,
    this.inMarket,
    this.sortIndex,
  });

  bool active;
  int sortIndex;
  @JsonKey(ignore: true)
  File imageFile;
  bool inMarket;

  factory PartnerOffer.fromJson(Map<String, dynamic> json) =>
      _$PartnerOfferFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerOfferToJson(this);
}
