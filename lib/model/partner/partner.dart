import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/model/user.dart';

part 'partner.g.dart';

@JsonSerializable()
class Partner extends User {
  Partner({
    this.fcmList,
    this.address,
    this.latitude,
    this.longitude,
    this.imgUrl,
  });

  List<String> fcmList;
  String imgUrl;
  Address address;
  double latitude;
  double longitude;

  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerToJson(this);
}
