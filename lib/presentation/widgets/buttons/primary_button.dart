import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';

import '../circular_progress_indicator.dart';

class PrimaryButtonController extends BaseController {
  final Key key;
  String text;
  final Color color;
  final VoidCallback onPressed;
  final double width;
  final double heigth;

  final double bottomPadding;
  final double topPadding;
  final TextStyle textStyle;
  final double radius;

  bool isLoading = false;

  PrimaryButtonController({
    this.key,
    this.textStyle,
    this.text,
    this.onPressed,
    this.color,
    this.bottomPadding,
    this.topPadding,
    this.width,
    this.radius,
    this.heigth,
  });
}

class PrimaryButton extends BaseView {
  final PrimaryButtonController controller;

  PrimaryButton({this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: controller.topPadding ?? getDefaultPadding(context) * 2,
          bottom: controller.bottomPadding ?? getDefaultPadding(context) * 2),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: controller.width ??
              ServiceProvider.instance.screenService
                  .getPortraitWidthByPercentage(context, 90),
          minHeight: ServiceProvider.instance.screenService
              .getPortraitHeightByPercentage(context, 7.5),
        ),
        child: RaisedButton(
            child: controller.isLoading
                ? CPI(false)
                : Text(
                    controller.text ?? "N/A",
                    style: controller.textStyle ??
                        ServiceProvider
                            .instance.instanceStyleService.appStyle.buttonText,
                    overflow: TextOverflow.ellipsis,
                  ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(controller.radius ??
                    ServiceProvider
                        .instance.instanceStyleService.appStyle.borderRadius),
              ),
            ),
            color: controller.color ??
                ServiceProvider.instance.instanceStyleService.appStyle.skyBlue,
            textColor: Colors.black,
            elevation: 0,
            onPressed: controller.onPressed),
      ),
    );
  }
}
