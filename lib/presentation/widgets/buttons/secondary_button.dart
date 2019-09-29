import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/service/service_provider.dart';

class SecondaryButton extends StatelessWidget {
  final Key key;
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double width;

  SecondaryButton({
    this.key,
    this.text,
    this.onPressed,
    this.color,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: width ??
              ServiceProvider.instance.screenService
                  .getPortraitWidthByPercentage(context, 50),
          minHeight: ServiceProvider.instance.screenService
              .getPortraitHeightByPercentage(context, 5)),
      child: RaisedButton(
          child: Text(text ?? "N/A",
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.buttonText),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          color: color ??
              ServiceProvider.instance.instanceStyleService.appStyle.green,
          textColor: Colors.black,
          elevation: 0,
          onPressed: onPressed),
    );
  }
}
