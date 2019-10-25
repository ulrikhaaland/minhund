import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class SaveButtonController extends BaseController {
  bool canSave;
  final VoidCallback onPressed;
  final String buttonText;

  SaveButtonController(
      {this.onPressed, this.canSave = true, this.buttonText = "Lagre"});
}

class SaveButton extends BaseView {
  final SaveButtonController controller;

  SaveButton({this.controller});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: controller.canSave
          ? ServiceProvider.instance.instanceStyleService.appStyle.green
          : Colors.transparent,
      radius: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard *
          0.7,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          ServiceProvider
                  .instance.instanceStyleService.appStyle.iconSizeStandard *
              0.7,
        ),
        onTap: () => controller.canSave ? controller.onPressed() : null,
        child: Center(
          child: Icon(
            Icons.check,
            size: ServiceProvider
                .instance.instanceStyleService.appStyle.iconSizeStandard,
            color: controller.canSave
                ? Colors.white
                : ServiceProvider
                    .instance.instanceStyleService.appStyle.inactiveIconColor,
          ),
        ),
      ),
    );
  }
}
