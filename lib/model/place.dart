import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable(anyMap: true)
class Place {
  Place({this.id, this.name, this.city, this.lat, this.long, this.type, this.description});
  String id;
  String name;
  String type;
  String city;
  String description;
  double lat;
  double long;

  factory Place.fromJson(Map json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
