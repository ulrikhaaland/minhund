// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map json) {
  return Place(
    id: json['id'] as String,
    name: json['name'] as String,
    city: json['city'] as String,
    type: json['type'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'name': instance.name,
      'type': instance.type,
      'lat': instance.lat,
      'long': instance.long,
    };
