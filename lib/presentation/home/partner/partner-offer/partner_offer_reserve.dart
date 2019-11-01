import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/model/partner/partner_reservation.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOfferReserveController extends BaseController {
  bool enabled = true;

  PartnerReservation reservation;

  bool expanded;

  PartnerOfferReserveController({this.enabled, this.reservation});

  @override
  void initState() {
    doCheck();
    super.initState();
  }

  doCheck() {
    if (reservation.canReserve == null) reservation.canReserve = false;

    if (reservation.notify == null) reservation.notify = false;

    expanded = reservation.canReserve;
  }
}

class PartnerOfferReserve extends BaseView {
  final PartnerOfferReserveController controller;

  PartnerOfferReserve({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return Material(
      borderRadius: BorderRadius.circular(
          ServiceProvider.instance.instanceStyleService.appStyle.borderRadius),
      elevation: 3,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ServiceProvider
              .instance.instanceStyleService.appStyle.borderRadius),
          color: controller.reservation.canReserve
              ? ServiceProvider.instance.instanceStyleService.appStyle.lightBlue
              : Colors.white,
        ),
        duration: Duration(milliseconds: 500),
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeSmall,
                  onPressed: () => showCustomDialog(
                    context: context,
                    dialogSize: DialogSize.medium,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Reservasjon",
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.descTitle,
                          ),
                          Container(
                            height: padding * 2,
                          ),
                          Text(
                            "Gir kunder muligeten til å reservere ditt tilbud i appen.\n\nFor hver reservasjon vil antallet synke automatisk og du vil få en notifikasjon samt informasjon om kunden som gjorde reservasjonen.",
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.body1,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                  icon: Icon(Icons.info_outline),
                ),
                if (controller.reservation.canReserve)
                  IconButton(
                    icon: Icon(controller.expanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                    iconSize: ServiceProvider.instance.instanceStyleService
                        .appStyle.iconSizeStandard,
                    onPressed: () => controller.setState(
                        () => controller.expanded = !controller.expanded),
                  )
              ],
            ),
            CheckboxListTile(
              title: Text(
                "Kan reserveres",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.smallTitle,
              ),
              value: controller.reservation.canReserve,
              onChanged: (val) => controller.enabled
                  ? controller.setState(() {
                      controller.reservation.canReserve =
                          !controller.reservation.canReserve;

                      controller.expanded = val;

                      if (val == false) {
                        controller.reservation.amount = null;
                        controller.reservation.notify = null;
                        controller.reservation.canReserve = null;

                        controller.doCheck();
                      }
                    })
                  : null,
              checkColor: Colors.white,
              activeColor:
                  ServiceProvider.instance.instanceStyleService.appStyle.green,
            ),
            if (controller.expanded) ...[
              Container(
                height: padding * 2,
              ),
              Padding(
                padding: EdgeInsets.only(left: padding * 2),
                child: PrimaryTextField(
                  initValue: controller.reservation.amount?.toString(),
                  enabled: controller.enabled,
                  textFieldType: TextFieldType.ordinary,
                  hintText: "Antall reservasjoner tilgjengelig",
                  asListTile: true,
                  onChanged: (val) => controller.reservation.amount =
                      val.isEmpty ? 0 : int.parse(val),
                  textInputType: TextInputType.number,
                  width: ServiceProvider.instance.screenService
                      .getWidthByPercentage(context, 50),
                ),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: CheckboxListTile(
                  title: Text(
                    "Få notifikasjon",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.smallTitle,
                  ),
                  value: controller.reservation.notify,
                  onChanged: (val) => controller.enabled
                      ? controller.setState(() {
                          controller.reservation.notify =
                              !controller.reservation.notify;
                        })
                      : null,
                  checkColor: Colors.white,
                  activeColor: ServiceProvider
                      .instance.instanceStyleService.appStyle.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
