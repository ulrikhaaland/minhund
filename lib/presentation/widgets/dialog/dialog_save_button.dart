import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class DialogSaveButtonController extends BaseController {
  bool canSave;
  final VoidCallback onPressed;
  final String buttonText;

  DialogSaveButtonController(
      {this.onPressed, this.canSave, this.buttonText = "Lagre"});
}

class DialogSaveButton extends BaseView {
  final DialogSaveButtonController controller;

  DialogSaveButton({this.controller});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onPressed(),
      child: CircleAvatar(
        backgroundColor: controller.canSave
            ? ServiceProvider.instance.instanceStyleService.appStyle.green
            : ServiceProvider
                .instance.instanceStyleService.appStyle.inactiveIconColor,
        // decoration: BoxDecoration(
        //     color: controller.canSave
        //         ? Colors.white
        //         : ServiceProvider
        //             .instance.instanceStyleService.appStyle.inactiveIconColor,
        //     borderRadius: BorderRadius.all(Radius.circular(200))),
        radius: 30,
        child: Center(
            child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () => null,
                iconSize: ServiceProvider
                    .instance.instanceStyleService.appStyle.iconSizeStandard,
                color: Colors.white)
            // Text(
            //   controller.buttonText,
            //   style: ServiceProvider
            //       .instance.instanceStyleService.appStyle.body1
            //       .copyWith(
            //     color: Colors.white,
            //   ),
            //   textAlign: TextAlign.left,
            // ),
            ),
      ),
    );
  }
}
