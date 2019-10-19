// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dog _$DogFromJson(Map json) {
  return Dog(
    name: json['name'] as String,
    weigth: json['weigth'] as String,
    birthDate: json['birthDate'] == null
        ? null
        : DateTime.parse(json['birthDate'] as String),
    race: json['race'] as String,
    address: json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map),
    chipNumber: json['chipNumber'] as String,
    id: json['id'] as String,
    imgUrl: json['imgUrl'] as String,
  );
}

Map<String, dynamic> _$DogToJson(Dog instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'weigth': instance.weigth,
      'chipNumber': instance.chipNumber,
      'imgUrl': instance.imgUrl,
      'address': instance.address?.toJson(),
      'birthDate': instance.birthDate?.toIso8601String(),
      'race': instance.race,
    };
