// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerReservation _$CustomerReservationFromJson(Map<String, dynamic> json) {
  return CustomerReservation(
    customerId: json['customerId'] as String,
    id: json['id'] as String,
    reservationName: json['reservationName'] as String,
    reservedAt: json['reservedAt'] == null
        ? null
        : DateTime.parse(json['reservedAt'] as String),
    amount: json['amount'] as int,
  );
}

Map<String, dynamic> _$CustomerReservationToJson(
        CustomerReservation instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'id': instance.id,
      'reservationName': instance.reservationName,
      'amount': instance.amount,
      'reservedAt': instance.reservedAt?.toIso8601String(),
    };
