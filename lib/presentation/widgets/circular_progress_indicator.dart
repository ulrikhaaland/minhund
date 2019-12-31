import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';

class CPI extends StatelessWidget {
  final bool positionInStack;
  const CPI({
    this.positionInStack = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cpi = CircularProgressIndicator(
      strokeWidth: 3,
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.lightBlue,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
    // Center CPI
    return positionInStack
        ? Positioned(
            left: ServiceProvider.instance.screenService
                .getWidthByPercentage(context, 45),
            top: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 50),
            child: cpi,
          )
        : cpi;
  }
}
