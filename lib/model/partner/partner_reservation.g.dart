// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerReservation _$PartnerReservationFromJson(Map<String, dynamic> json) {
  return PartnerReservation(
    amount: json['amount'] as int,
    notify: json['notify'] as bool,
    canReserve: json['canReserve'] as bool,
  );
}

Map<String, dynamic> _$PartnerReservationToJson(PartnerReservation instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'notify': instance.notify,
      'canReserve': instance.canReserve,
    };
