import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(anyMap: true)
class Address {
  Address({this.address, this.city, this.county, this.zip});
  String city;
  String zip;
  String county;
  String address;

  factory Address.fromJson(Map json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
