import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

abstract class DialogTemplateController extends BaseController {
  String get title;

  Widget get actionOne;
  Widget get actionTwo;
}

abstract class DialogTemplate extends BaseView {
  final DialogTemplateController controller;

  DialogTemplate({this.controller});
  @override
  Widget build(BuildContext context) {
    double padding = getDefaultPadding(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, padding * 2, padding, padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            alignment: Alignment.centerLeft,
            height: constraints.maxHeight * 0.1,
            width: constraints.maxWidth != null
                ? (constraints.maxWidth * 0.935) / 2
                : null,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: constraints.maxWidth / 4,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: getDefaultPadding(context) * 2),
                              child: controller.actionOne ?? Container(),
                            ))),
                    Container(
                      width: constraints.maxWidth / 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          controller.title ?? "",
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.smallTitle,
                        ),
                      ),
                    ),
                    Container(
                        width: constraints.maxWidth / 4,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: getDefaultPadding(context) * 2),
                              child: controller.actionTwo ?? Container(),
                            ))),
                  ],
                ),
                Expanded(child: buildDialogContent(context)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDialogContent(BuildContext context);
}
