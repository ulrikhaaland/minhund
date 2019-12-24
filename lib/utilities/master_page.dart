import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/service/service_provider.dart';

abstract class MasterPageController extends BaseController {
  Widget get fab;

  String get title;

  Widget get bottomNav;

  bool get enabledTopSafeArea;

  Widget get actionOne;
  List<Widget> get actionTwoList;
}

abstract class MasterPage extends BaseView {
  final MasterPageController controller;

  MasterPage({this.controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));

    Widget appBar;

    if (controller.title != null ||
        controller.actionOne != null ||
        controller.actionTwoList != null)
      appBar = AppBar(
        iconTheme: IconThemeData(
            color:
                ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
            size: ServiceProvider
                .instance.instanceStyleService.appStyle.iconSizeBig),
        elevation: 0,
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        centerTitle: true,
        leading: controller.actionOne,
        title: Text(
          controller.title ?? "",
          style: ServiceProvider.instance.instanceStyleService.appStyle.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          if (controller.actionTwoList != null)
            Padding(
              padding: EdgeInsets.only(right: getDefaultPadding(context) * 2),
              child: Row(
                    children: controller.actionTwoList
                        .map((action) => action)
                        .toList(),
                  ) ??
                  Container(),
            )
        ],
      );

    return TapToUnfocus(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            backgroundColor: ServiceProvider
                .instance.instanceStyleService.appStyle.backgroundColor,
            appBar: appBar,
            bottomNavigationBar: controller.bottomNav,
            floatingActionButton: controller.fab,
            body: SafeArea(
                top: controller.enabledTopSafeArea ?? true,
                child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: controller.enabledTopSafeArea == true
                            ? MediaQuery.of(context).padding.top
                            : 0),
                    height: MediaQuery.of(context).size.height -
                        (controller.enabledTopSafeArea == true
                            ? MediaQuery.of(context).padding.top
                            : 0),
                    child: buildContent(context)))));
  }

  Widget buildContent(BuildContext context);
}
