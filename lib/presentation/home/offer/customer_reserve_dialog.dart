import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/customer/customer_reservation.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/circular_progress_indicator.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class CustomerReserveDialogController extends DialogTemplateController {
  final User user;

  Offer offer;

  TextEditingController textEditingController =
      TextEditingController(text: "1");

  CustomerReservation customerReservation;

  bool reservationCompleted;

  CustomerReserveDialogController({this.user, this.offer});

  @override
  void initState() {
    checkIfAlreadyReserved();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => reservationCompleted == false
      ? SaveButton(
          controller: SaveButtonController(onPressed: () async {
            if (offer.partnerReservation.amount != null) {
              if (offer.partnerReservation.amount <
                  customerReservation.amount) {
                Navigator.of(context).pop();
              } else {
                offer.partnerReservation.amount -= customerReservation.amount;
                Firestore.instance.runTransaction((tx) {
                  return tx.update(offer.docRef, offer.toJson());
                });
              }
            }

            customerReservation.reservedAt = DateTime.now();
            Firestore.instance
                .document(offer.docRef.path + "/reservations/${user.id}")
                .setData(
                  customerReservation.toJson(),
                );

            setState(() => reservationCompleted = true);
          }),
        )
      : null;

  @override
  String get title => reservationCompleted == false ? "Reserver" : "Reservert!";

  checkIfAlreadyReserved() async {
    DocumentSnapshot docSnap = await Firestore.instance
        .document(offer.docRef.path + "/reservations/${user.id}")
        .get();
    setState(() {
      if (docSnap.exists) {
        customerReservation = CustomerReservation.fromJson(docSnap.data);
        reservationCompleted = true;
      } else {
        customerReservation = CustomerReservation(
          amount: 1,
          customerId: user.id,
          reservationName: user.name ?? user.dog.name,
          phoneNumber: user.phoneNumber ?? "",
        );

        reservationCompleted = false;
      }
    });
  }

  @override
  // TODO: implement withBorder
  bool get withBorder => null;
}

class CustomerReserveDialog extends DialogTemplate {
  final CustomerReserveDialogController controller;

  CustomerReserveDialog({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.reservationCompleted == null)
      return Center(child: CPI(false));

    double padding = getDefaultPadding(context);

    if (!controller.reservationCompleted)
      return TapToUnfocus(
        child: Padding(
          padding: EdgeInsets.all(padding * 2),
          child: Column(
            children: <Widget>[
              if (controller.offer.partnerReservation.canReserveMultiple &&
                  controller.offer.partnerReservation.amount > 1) ...[
                Text(
                  "For dette tilbudet kan du maksimum reservere ${controller.offer.partnerReservation.canReserveMultipleAmount} stk",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.italic,
                ),
                Container(
                  height: padding * 4,
                ),
                PrimaryTextField(
                  hintText: "Antall",
                  asListTile: true,
                  textEditingController: controller.textEditingController,
                  initValue: controller.customerReservation.amount.toString(),
                  textFieldType: TextFieldType.ordinary,
                  textInputType: TextInputType.number,
                  onChanged: (val) {
                    int reserveValue = int.parse(val);
                    if (reserveValue == 0) {
                      controller.textEditingController.text = "1";
                    } else if (reserveValue <=
                        controller.offer.partnerReservation
                            .canReserveMultipleAmount) {
                      controller.customerReservation.amount = reserveValue;
                    } else {
                      controller.textEditingController.text = controller
                          .offer.partnerReservation.canReserveMultipleAmount
                          .toString();
                    }
                    controller.setState(() {});
                  },
                ),
              ] else ...[
                Text(
                  "For dette tilbudet kan du kun reservere 1 stk",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.italic,
                ),
                Container(
                  height: padding * 4,
                ),
              ],
              PrimaryTextField(
                paddingBottom: padding * 2,
                hintText: "Telefonnummer",
                prefixText: "+47 ",
                asListTile: true,
                initValue: controller.customerReservation.phoneNumber,
                textFieldType: TextFieldType.ordinary,
                textInputType: TextInputType.number,
                onChanged: (val) {
                  controller.customerReservation.phoneNumber = val;
                },
              ),
               PrimaryTextField(
                paddingBottom: padding * 2,
                hintText: "Ditt navn",
                asListTile: true,
                initValue: controller.customerReservation.reservationName,
                textCapitalization: TextCapitalization.words,
                textFieldType: TextFieldType.ordinary,
                textInputType: TextInputType.number,
                onChanged: (val) {
                  controller.customerReservation.reservationName = val;
                },
              ),
              PrimaryTextField(
                hintText: "Melding til butikk",
                asListTile: true,
                maxLines: 5,
                textFieldType: TextFieldType.ordinary,
                onChanged: (val) {
                  controller.customerReservation.message = val;
                },
              ),
            ],
          ),
        ),
      );

    return Padding(
      padding: EdgeInsets.all(padding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check,
            color:
                ServiceProvider.instance.instanceStyleService.appStyle.skyBlue,
            size: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 20),
          ),
          Text(
            "Din reservasjon for ${controller.customerReservation.amount} stk ${controller.offer.title} kan hentes i butikk${ controller.customerReservation.reservationName != null && controller.customerReservation.reservationName != "" ? " under navnet " + controller.customerReservation.reservationName : null}.",
            style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
