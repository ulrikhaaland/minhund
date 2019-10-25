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
  );
}

Map<String, dynamic> _$PartnerOfferToJson(PartnerOffer instance) =>
    <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'desc': instance.desc,
      'imgUrl': instance.imgUrl,
      'endOfOffer': instance.endOfOffer?.toIso8601String(),
    };
