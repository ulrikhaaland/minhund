import 'package:json_annotation/json_annotation.dart';

part 'partner_reservation.g.dart';

@JsonSerializable()
class PartnerReservation {
  PartnerReservation({
    this.amount,
    this.notify,
    this.canReserve,
  });
  int amount;
  bool notify;
  bool canReserve;

  factory PartnerReservation.fromJson(Map<String, dynamic> json) =>
      _$PartnerReservationFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerReservationToJson(this);
}
