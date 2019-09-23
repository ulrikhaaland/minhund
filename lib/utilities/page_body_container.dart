import 'package:minhund/helper/helper.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final String loadMessage;
  final Color overrideBackgroundColor;
  final bool displayBambooText;

  PageContainer({
    this.padding,
    this.loadMessage,
    Key key,
    this.overrideBackgroundColor,
    this.child,
    this.displayBambooText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = overrideBackgroundColor ??
        ServiceProvider.instance.instanceStyleService.appStyle.backgroundColor;

    return LayoutBuilder(
      builder: (con, constraints) {
        List<Widget> widgets = <Widget>[
          displayBambooText
              ? Positioned(
                  bottom: 0,
                  child: Container(
                    width: constraints.maxWidth,
                    child: Center(
                      child: Text(
                        'BAMBOO',
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title
                            .copyWith(
                          color: ServiceProvider.instance.instanceStyleService
                              .appStyle.title.color
                              .withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          child ?? Container(),
        ];

        if (loadMessage != null) {
          widgets.add(new Opacity(
            opacity: 0.0,
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ));

          widgets.add(Container(
            width: ServiceProvider.instance.screenService.getWidth(context),
            height: ServiceProvider.instance.screenService.getHeight(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor:
                      ServiceProvider.instance.instanceStyleService.appStyle ==
                              null
                          ? Colors.grey
                          : ServiceProvider.instance.instanceStyleService
                                  .appStyle.themeColor ??
                              Colors.green,
                ),
                loadMessage != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          loadMessage != null ? loadMessage : "Load message",
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.label,
                        ),
                      )
                    : Container(),
              ],
            ),
          ));
        }

        return SafeArea(
          bottom: true,
          top: false,
          right: false,
          left: false,
          child: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              gradient: overrideBackgroundColor != Colors.transparent
                  ? LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.1, 0.5, 0.7, 1],
                      colors: [
                        backgroundColor,
                        backgroundColor.withAlpha(235),
                        backgroundColor.withAlpha(220),
                        backgroundColor.withAlpha(210),
                      ],
                    )
                  : null,
              color: overrideBackgroundColor == Colors.transparent
                  ? Colors.transparent
                  : null,
            ),
            child: new Padding(
              padding: padding ??
                  EdgeInsets.all(
                    getDefaultPadding(context),
                  ),
              child: Stack(
                children: widgets,
              ),
            ),
          ),
        );
      },
    );
  }
}
