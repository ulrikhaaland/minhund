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
    partnerReservation: json['partnerReservation'] == null
        ? null
        : PartnerReservation.fromJson((json['partnerReservation'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    id: json['id'] as String,
    partnerId: json['partnerId'] as String,
    discountCode: json['discountCode'] as String,
    url: json['url'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
    type: _$enumDecodeNullable(_$OfferTypeEnumMap, json['type']),
  )
    ..partner = json['partner'] == null
        ? null
        : Partner.fromJson((json['partner'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..distanceInKm = (json['distanceInKm'] as num)?.toDouble();
}

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'title': instance.title,
      'price': instance.price,
      'lat': instance.lat,
      'long': instance.long,
      'partner': instance.partner.toJson(),
      'desc': instance.desc,
      'imgUrl': instance.imgUrl,
      'url': instance.url,
      'distanceInKm': instance.distanceInKm,
      'endOfOffer': instance.endOfOffer?.toIso8601String(),
      'type': _$OfferTypeEnumMap[instance.type],
      'partnerId': instance.partnerId,
      'discountCode': instance.discountCode,
      'partnerReservation': instance.partnerReservation.toJson(),
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
