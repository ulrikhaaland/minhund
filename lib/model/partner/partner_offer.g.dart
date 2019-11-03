// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerOffer _$PartnerOfferFromJson(Map json) {
  return PartnerOffer(
    active: json['active'] as bool,
    inMarket: json['inMarket'] as bool,
    sortIndex: json['sortIndex'] as int,
  )
    ..id = json['id'] as String
    ..partnerId = json['partnerId'] as String
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..title = json['title'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..desc = json['desc'] as String
    ..imgUrl = json['imgUrl'] as String
    ..endOfOffer = json['endOfOffer'] == null
        ? null
        : DateTime.parse(json['endOfOffer'] as String)
    ..type = json['type'] as String
    ..partnerReservation = json['partnerReservation'] == null
        ? null
        : PartnerReservation.fromJson((json['partnerReservation'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

Map<String, dynamic> _$PartnerOfferToJson(PartnerOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partnerId': instance.partnerId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'title': instance.title,
      'price': instance.price,
      'desc': instance.desc,
      'imgUrl': instance.imgUrl,
      'endOfOffer': instance.endOfOffer?.toIso8601String(),
      'type': instance.type,
      'partnerReservation': instance.partnerReservation.toJson(),
      'active': instance.active,
      'sortIndex': instance.sortIndex,
      'inMarket': instance.inMarket,
    };
