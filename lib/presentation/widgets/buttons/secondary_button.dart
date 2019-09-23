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
    return Padding(
      padding: EdgeInsets.only(
          top: getDefaultPadding(context) * 4,
          bottom: getDefaultPadding(context) * 4),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: width ??
                ServiceProvider.instance.screenService
                    .getPortraitWidthByPercentage(context, 90),
            minHeight: ServiceProvider.instance.screenService
                .getPortraitHeightByPercentage(context, 6)),
        child: RaisedButton(
            child: Text(text ?? "N/A",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.buttonText),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            color: color ??
                ServiceProvider.instance.instanceStyleService.appStyle.imperial,
            textColor: Colors.black,
            elevation: 0,
            onPressed: onPressed),
      ),
    );
  }
}
