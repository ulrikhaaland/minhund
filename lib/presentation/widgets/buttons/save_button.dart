import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/circular_progress_indicator.dart';
import 'package:minhund/service/service_provider.dart';

class SaveButtonController extends BaseController {
  bool canSave;
  final VoidCallback onPressed;
  final String buttonText;
  bool isLoading = false;

  SaveButtonController({
    this.onPressed,
    this.canSave = true,
    this.buttonText = "Lagre",
  });

  void load() {
    setState(() => isLoading != isLoading);
  }
}

class SaveButton extends BaseView {
  final SaveButtonController controller;

  SaveButton({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double iconSizeStandard =
        ServiceProvider.instance.instanceStyleService.appStyle.iconSizeStandard;

    return Padding(
      padding: EdgeInsets.only(left: getDefaultPadding(context) * 2.1),
      child: AnimatedContainer(
        curve: Curves.decelerate,
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: controller.canSave
              ? ServiceProvider.instance.instanceStyleService.appStyle.green
              : ServiceProvider
                  .instance.instanceStyleService.appStyle.backgroundColor,
          shape: BoxShape.circle,
        ),
        height: iconSizeStandard * 1.2,
        width: iconSizeStandard * 1.2,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            iconSizeStandard * 0.7,
          ),
          onTap: () => controller.canSave ? controller.onPressed() : null,
          child: Center(
            child: controller.isLoading
                ? CPI(false)
                : Icon(
                    Icons.check,
                    size: iconSizeStandard,
                    color: controller.canSave
                        ? Colors.white
                        : ServiceProvider.instance.instanceStyleService.appStyle
                            .inactiveIconColor,
                  ),
          ),
        ),
      ),
    );
  }
}
