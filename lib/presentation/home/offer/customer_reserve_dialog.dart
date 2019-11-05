import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class CustomerReserveDialogController extends DialogTemplateController {
  final User user;

  Offer offer;

  int reservationAmount = 1;

  TextEditingController textEditingController =
      TextEditingController(text: "1");

  String phoneNumber;

  String messageToStore;

  CustomerReserveDialogController({this.user, this.offer});
  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => SaveButton(
        controller: SaveButtonController(onPressed: () {}),
      );

  @override
  String get title => "Reserver";

  @override
  void initState() {
    phoneNumber = user.phoneNumber ?? "";
    super.initState();
  }
}

class CustomerReserveDialog extends DialogTemplate {
  final CustomerReserveDialogController controller;

  CustomerReserveDialog({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return TapToUnfocus(
      child: Padding(
        padding: EdgeInsets.all(padding * 2),
        child: Column(
          children: <Widget>[
            if (controller.offer.partnerReservation.canReserveMultiple &&
                controller.offer.partnerReservation.amount > 1) ...[
              PrimaryTextField(
                hintText: "Antall",
                asListTile: true,
                textEditingController: controller.textEditingController,
                initValue: controller.reservationAmount.toString(),
                textFieldType: TextFieldType.ordinary,
                textInputType: TextInputType.number,
                onChanged: (val) {
                  int reserveValue = int.parse(val);
                  if (reserveValue == 0) {
                    controller.textEditingController.text = "1";
                  } else if (reserveValue <=
                      controller
                          .offer.partnerReservation.canReserveMultipleAmount) {
                    controller.reservationAmount = reserveValue;
                  } else {
                    controller.textEditingController.text = controller
                        .offer.partnerReservation.canReserveMultipleAmount
                        .toString();
                  }
                  controller.setState(() {});
                },
              ),
              Text(
                "For denne varen kan du maksimum reservere ${controller.offer.partnerReservation.canReserveMultipleAmount} stk",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.italic,
              ),
            ] else ...[
              Text(
                "For denne varen kan du kun reservere 1 stk",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.italic,
              ),
            ],
            Container(
              height: padding * 6,
            ),
            PrimaryTextField(
              hintText: "Telefonnummer",
              asListTile: true,
              initValue: controller.phoneNumber,
              textFieldType: TextFieldType.ordinary,
              textInputType: TextInputType.number,
              onChanged: (val) {
                controller.phoneNumber = val;
              },
            ),
            PrimaryTextField(
              hintText: "Melding til butikk",
              asListTile: true,
              maxLines: 5,
              textFieldType: TextFieldType.ordinary,
              onChanged: (val) {
                controller.messageToStore = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
