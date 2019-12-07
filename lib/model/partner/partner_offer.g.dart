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
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..title = json['title'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..lat = (json['lat'] as num)?.toDouble()
    ..long = (json['long'] as num)?.toDouble()
    ..partner = json['partner'] == null
        ? null
        : Partner.fromJson((json['partner'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..desc = json['desc'] as String
    ..imgUrl = json['imgUrl'] as String
    ..discountCode = json['discountCode'] as String
    ..url = json['url'] as String
    ..distanceInKm = (json['distanceInKm'] as num)?.toDouble()
    ..endOfOffer = json['endOfOffer'] == null
        ? null
        : DateTime.parse(json['endOfOffer'] as String)
    ..type = _$enumDecodeNullable(_$OfferTypeEnumMap, json['type'])
    ..partnerId = json['partnerId'] as String
    ..partnerReservation = json['partnerReservation'] == null
        ? null
        : PartnerReservation.fromJson((json['partnerReservation'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

Map<String, dynamic> _$PartnerOfferToJson(PartnerOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'title': instance.title,
      'price': instance.price,
      'lat': instance.lat,
      'long': instance.long,
      'partner': instance.partner.toJson(),
      'desc': instance.desc,
      'imgUrl': instance.imgUrl,
      'discountCode': instance.discountCode,
      'url': instance.url,
      'distanceInKm': instance.distanceInKm,
      'endOfOffer': instance.endOfOffer?.toIso8601String(),
      'type': _$OfferTypeEnumMap[instance.type],
      'partnerId': instance.partnerId,
      'partnerReservation': instance.partnerReservation.toJson(),
      'active': instance.active,
      'sortIndex': instance.sortIndex,
      'inMarket': instance.inMarket,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$OfferTypeEnumMap = {
  OfferType.item: 'item',
  OfferType.service: 'service',
  OfferType.online: 'online',
};
