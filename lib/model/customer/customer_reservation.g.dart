// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerReservation _$CustomerReservationFromJson(Map<String, dynamic> json) {
  return CustomerReservation(
    customerId: json['customerId'] as String,
    didComeThrough: json['didComeThrough'] as bool,
    id: json['id'] as String,
    reservationName: json['reservationName'] as String,
    message: json['message'] as String,
    phoneNumber: json['phoneNumber'] as String,
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
      'didComeThrough': instance.didComeThrough,
      'message': instance.message,
      'reservationName': instance.reservationName,
      'phoneNumber': instance.phoneNumber,
      'amount': instance.amount,
      'reservedAt': instance.reservedAt?.toIso8601String(),
    };
