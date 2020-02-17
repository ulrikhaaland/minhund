import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/customer/customer_reservation.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/service/service_provider.dart';

class ReservationDialogController extends DialogTemplateController {
  final List<CustomerReservation> customerReservations;

  final Partner partner;

  final Offer offer;

  ReservationDialogController(
      {this.offer, this.partner, this.customerReservations});

  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => IconButton(
        iconSize: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeSmall,
        onPressed: () {
          double padding = getDefaultPadding(context);
          showCustomDialog(
            context: context,
            dialogSize: DialogSize.medium,
            child: Padding(
              padding: EdgeInsets.all(padding * 2),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Reservasjoner",
                    textAlign: TextAlign.center,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.descTitle,
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Text(
                    "Her havner alle reservasjoner for dette tilbudet.",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Text(
                    'Når varen blir plukket opp markeres dette ved å trykke på "check-ikonet"',
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                    textAlign: TextAlign.start,
                  ),
                  Icon(
                    Icons.check,
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.green,
                    size: ServiceProvider
                        .instance.instanceStyleService.appStyle.iconSizeBig,
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Text(
                    'Hvis kunden ikke skulle plukke opp varen eller noe annet har gått galt, fjernes reservasjonen ved å trykke på "kryss-ikonet"',
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                    textAlign: TextAlign.start,
                  ),
                  Icon(
                    Icons.close,
                    size: ServiceProvider
                        .instance.instanceStyleService.appStyle.iconSizeBig,
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Text(
                    "Når salgsdataen har blitt samlet vil Min Hund kunne presentere det i form av statistikk og tips for å gi dere en lønnsommere bedrift.",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          );
        },
        icon: Icon(Icons.info_outline),
      );

  @override
  String get title => "Reservasjoner";

  void deleteReservation({CustomerReservation reservation}) {
    setState(() {
      customerReservations.remove(reservation);
    });
    reservation.docRef.delete();
    reservation.didComeThrough = false;
    partner.docRef
        .collection("offers")
        .document(offer.id)
        .collection("reservations")
        .document(reservation.id)
        .setData(reservation.toJson());
  }

  void confirmReservationSale({CustomerReservation reservation}) {
    setState(() {
      customerReservations.remove(reservation);
    });
    reservation.docRef.delete();
    reservation.didComeThrough = true;

    partner.docRef
        .collection("offers")
        .document(offer.id)
        .collection("reservations")
        .document(reservation.id)
        .setData(reservation.toJson());
  }

  @override
  // TODO: implement withBorder
  bool get withBorder => null;
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
                    IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () => controller.confirmReservationSale(
                                reservation: reservation),
                            icon: Icon(Icons.check),
                            color: ServiceProvider
                                .instance.instanceStyleService.appStyle.green,
                            iconSize: ServiceProvider.instance
                                .instanceStyleService.appStyle.iconSizeStandard,
                          ),
                          IconButton(
                            onPressed: () => controller.deleteReservation(
                                reservation: reservation),
                            icon: Icon(Icons.clear),
                            iconSize: ServiceProvider.instance
                                .instanceStyleService.appStyle.iconSizeStandard,
                          ),
                        ],
                      ),
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
