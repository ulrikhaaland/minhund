import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/customer/customer_reservation.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/service/service_provider.dart';

class ReservationDialogController extends DialogTemplateController {
  final List<CustomerReservation> customerReservations;

  ReservationDialogController({this.customerReservations});

  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => null;

  @override
  String get title => "Reservasjoner";

  void deleteReservation({CustomerReservation reservation}) {
    setState(() {
      customerReservations.remove(reservation);
    });
    reservation.docRef.delete();
  }
}

class ReservationDialog extends DialogTemplate {
  final ReservationDialogController controller;

  ReservationDialog({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return Padding(
      padding: EdgeInsets.all(padding * 2),
      child: Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 75),
        child: Column(
          children: <Widget>[
            ListView.builder(
              key: Key(controller.customerReservations.length.toString()),
              shrinkWrap: true,
              itemCount: controller.customerReservations.length,
              itemBuilder: (context, index) {
                CustomerReservation reservation =
                    controller.customerReservations[index];
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ServiceProvider
                              .instance
                              .instanceStyleService
                              .appStyle
                              .borderRadius),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(padding * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                formatDate(
                                      date: reservation.reservedAt,
                                    ) ??
                                    "",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.timestamp,
                              ),
                              if (reservation.reservationName != null) ...[
                                Container(
                                  height: padding,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Navn: ",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.italic,
                                    ),
                                    Text(reservation.reservationName,
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .body1Black),
                                  ],
                                ),
                              ],
                              if (reservation.amount != null) ...[
                                Container(
                                  height: padding,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Antall: ",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.italic,
                                    ),
                                    Text(reservation.amount.toString(),
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .body1Black),
                                  ],
                                ),
                              ],
                              if (reservation.phoneNumber != null) ...[
                                Container(
                                  height: padding,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Tlf: ",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.italic,
                                    ),
                                    Text(reservation.phoneNumber,
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .body1Black),
                                  ],
                                ),
                              ],
                              if (reservation.message != null) ...[
                                Container(
                                  height: padding,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    IntrinsicHeight(
                                      child: Text(
                                        "Melding: ",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .italic,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        reservation.message,
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .body1Black,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.deleteReservation(
                          reservation: reservation),
                      icon: Icon(Icons.delete),
                      iconSize: ServiceProvider.instance.instanceStyleService
                          .appStyle.iconSizeStandard,
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
