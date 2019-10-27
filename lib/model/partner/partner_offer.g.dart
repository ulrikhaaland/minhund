// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerOffer _$PartnerOfferFromJson(Map<String, dynamic> json) {
  return PartnerOffer(
    title: json['title'] as String,
    desc: json['desc'] as String,
    price: (json['price'] as num)?.toDouble(),
    imgUrl: json['imgUrl'] as String,
    endOfOffer: json['endOfOffer'] == null
        ? null
        : DateTime.parse(json['endOfOffer'] as String),
    id: json['id'] as String,
  )
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..sortIndex = json['sortIndex'] as int
    ..active = json['active'] as bool
    ..type = json['type'] as String
    ..inMarket = json['inMarket'] as bool;
}

Map<String, dynamic> _$PartnerOfferToJson(PartnerOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'title': instance.title,
      'price': instance.price,
      'desc': instance.desc,
      'sortIndex': instance.sortIndex,
      'imgUrl': instance.imgUrl,
      'endOfOffer': instance.endOfOffer?.toIso8601String(),
      'active': instance.active,
      'type': instance.type,
      'inMarket': instance.inMarket,
    };
