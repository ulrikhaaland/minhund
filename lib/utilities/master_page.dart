import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

abstract class MasterPageController extends BaseController {
  FloatingActionButton get fab;

  String get title;

  Widget get bottomNav;

  Widget get actionOne;
  Widget get actionTwo;
}

abstract class MasterPage extends BaseView {
  final MasterPageController controller;

  MasterPage({this.controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    Widget appBar;

    if (controller.title != null ||
        controller.actionOne != null ||
        controller.actionTwo != null)
      appBar = AppBar(
        elevation: 0,
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        centerTitle: true,
        leading: controller.actionOne,
        title: Text(
          controller.title ?? "",
          style: ServiceProvider.instance.instanceStyleService.appStyle.title,
        ),
        actions: <Widget>[controller.actionTwo ?? Container()],
      );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          appBar: appBar,
          bottomNavigationBar: controller.bottomNav,
          floatingActionButton: controller.fab,
          body: LayoutBuilder(
            builder: (context, con) {
              return Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                      child: Container(
                          height: con.maxHeight,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: ServiceProvider.instance.screenService
                                    .getHeightByPercentage(context, 2),
                              ),
                              Expanded(child: buildContent(context)),
                            ],
                          ))));
            },
          )),
    );
  }

  Widget buildContent(BuildContext context);
}