import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';

class HenvendAppBar extends StatelessWidget implements PreferredSize {
  final String title;
  final Widget leftIcon;
  final Widget rightIcon;
  final TextStyle titleStyle;
  Size size;

  HenvendAppBar({
    Key key,
    this.leftIcon,
    this.rightIcon,
    this.title,
    this.titleStyle,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = Size(
        0,
        ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 25));
    return PreferredSize(
      preferredSize: size,
      child: Padding(
        padding: EdgeInsets.only(
          top: ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 5),
          right: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 2),
          left: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 2),
          // bottom: ServiceProvider.instance.screenService
          //     .getHeightByPercentage(context, 5),
        ),
        child: Row(
          children: <Widget>[
            Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 13),
                child: leftIcon ?? Container()),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: ServiceProvider.instance.screenService
                  .getWidthByPercentage(context, 70),
              child: Text(
                title ?? "N/A",
                textAlign: TextAlign.center,
                style: titleStyle ??
                    ServiceProvider
                        .instance.instanceStyleService.appStyle.titleGrey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 13),
                child: rightIcon ?? Container()),
            // Container(
            //   width: ServiceProvider.instance.screenService
            //       .getWidthByPercentage(context, 13),
            //   child: GestureDetector(
            //     onTap: () => _dialog(context, false),
            //     child: new Image.asset(
            //       "lib/assets/images/logo_sunglow.ico",
            //       scale: 6,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => null;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(100, 100);
}
