import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_reservation.g.dart';

@JsonSerializable()
class CustomerReservation {
  CustomerReservation(
      {this.customerId,
      this.id,
      this.reservationName,
      this.message,
      this.phoneNumber,
      this.reservedAt,
      this.amount});
  String customerId;
  String id;
  String message;
  String reservationName;
  String phoneNumber;
  int amount;
  DateTime reservedAt;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory CustomerReservation.fromJson(Map<String, dynamic> json) =>
      _$CustomerReservationFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerReservationToJson(this);
}
