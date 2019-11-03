// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map json) {
  return Offer(
    title: json['title'] as String,
    desc: json['desc'] as String,
    price: (json['price'] as num)?.toDouble(),
    imgUrl: json['imgUrl'] as String,
    endOfOffer: json['endOfOffer'] == null
        ? null
        : DateTime.parse(json['endOfOffer'] as String),
    partnerId: json['partnerId'] as String,
    partnerReservation: json['partnerReservation'] == null
        ? null
        : PartnerReservation.fromJson((json['partnerReservation'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'partnerId': instance.partnerId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'title': instance.title,
      'price': instance.price,
      'desc': instance.desc,
      'imgUrl': instance.imgUrl,
      'endOfOffer': instance.endOfOffer?.toIso8601String(),
      'type': instance.type,
      'partnerReservation': instance.partnerReservation,
    };
