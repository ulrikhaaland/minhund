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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ServiceProvider
                .instance.instanceStyleService.appStyle.backgroundColor,
            centerTitle: true,
            leading: controller.actionOne,
            title: Text(
              controller.title ?? "Tilfeldig",
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.title,
            ),
            actions: <Widget>[controller.actionTwo ?? Container()],
          ),
          bottomNavigationBar: controller.bottomNav,
          floatingActionButton: controller.fab,
          body: LayoutBuilder(
            builder: (context, con) {
              return Container(
                  alignment: Alignment.center, child: buildContent(context));
            },
          )),
    );
  }

  Widget buildContent(BuildContext context);
}
