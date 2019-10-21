import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class DialogSaveButtonController extends BaseController {
  bool canSave;
  final VoidCallback onPressed;
  final String buttonText;

  DialogSaveButtonController(
      {this.onPressed, this.canSave = true, this.buttonText = "Lagre"});
}

class DialogSaveButton extends BaseView {
  final DialogSaveButtonController controller;

  DialogSaveButton({this.controller});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: controller.canSave
          ? ServiceProvider.instance.instanceStyleService.appStyle.green
          : ServiceProvider
              .instance.instanceStyleService.appStyle.inactiveIconColor,
      radius: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard *
          0.8,
      child: InkWell(
        onTap: () => controller.onPressed(),
        child: Center(
          child: Icon(Icons.check,
              size: ServiceProvider
                  .instance.instanceStyleService.appStyle.iconSizeStandard,
              color: Colors.white),
        ),
      ),
    );
  }
}
