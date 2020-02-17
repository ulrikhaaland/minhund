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
    description: json['description'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'city': instance.city,
      'description': instance.city,
      'lat': instance.lat,
      'long': instance.long,
    };
