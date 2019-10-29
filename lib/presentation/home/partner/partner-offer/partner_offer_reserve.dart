import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOfferReserveController extends BaseController {
  bool enabled = true;

  bool reserve = true;

  bool expanded = true;
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
          color: controller.expanded
              ? ServiceProvider.instance.instanceStyleService.appStyle.lightBlue
              : Colors.white,
        ),
        duration: Duration(milliseconds: 1000),
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 80),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      "Kan reserveres",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.smallTitle,
                    ),
                    value: controller.reserve,
                    onChanged: (val) => controller.enabled
                        ? controller.setState(() {
                            controller.reserve = !controller.reserve;
                            controller.expanded = val;
                          })
                        : null,
                    checkColor: Colors.white,
                    activeColor: ServiceProvider
                        .instance.instanceStyleService.appStyle.green,
                  ),
                ),
              ],
            ),
            if (controller.expanded) ...[
              Container(
                height: padding * 2,
              ),
              PrimaryTextField(
                hintText: "Antall reservasjoner tilgjengelig",
                asListTile: true,
              )
            ],
          ],
        ),
      ),
    );
  }
}
