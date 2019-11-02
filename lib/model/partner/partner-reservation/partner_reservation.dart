import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/partner/partner-reservation/customer_reservation.dart';

part 'partner_reservation.g.dart';

@JsonSerializable()
class PartnerReservation {
  PartnerReservation({
    this.amount,
    this.notify,
    this.canReserve,
    this.canReserveMultiple,
    this.canReserveMultipleAmount,
  });
  int amount;
  bool notify;
  bool canReserve;
  bool canReserveMultiple;
  int canReserveMultipleAmount;
  @JsonKey(ignore: true)
  List<CustomerReservation> customerReservations;

  factory PartnerReservation.fromJson(Map<String, dynamic> json) =>
      _$PartnerReservationFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerReservationToJson(this);
}
