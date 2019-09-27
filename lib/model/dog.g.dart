// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dog _$DogFromJson(Map<String, dynamic> json) {
  return Dog(
    name: json['name'] as String,
    weigth: json['weigth'] as String,
    birthDate: json['birthDate'] == null
        ? null
        : DateTime.parse(json['birthDate'] as String),
    race: json['race'] as String,
    veterinaryVisits: (json['veterinaryVisits'] as List)
        ?.map((e) => e == null
            ? null
            : VeterinaryVisit.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    courses: (json['courses'] as List)
        ?.map((e) =>
            e == null ? null : Course.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    address: json['address'] as String,
  );
}

Map<String, dynamic> _$DogToJson(Dog instance) => <String, dynamic>{
      'name': instance.name,
      'weigth': instance.weigth,
      'birthDate': instance.birthDate?.toIso8601String(),
      'race': instance.race,
      'address': instance.address,
      'veterinaryVisits': instance.veterinaryVisits,
      'courses': instance.courses,
    };
