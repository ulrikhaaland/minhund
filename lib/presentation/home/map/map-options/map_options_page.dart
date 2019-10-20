import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/map/map_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class MapOptionsPageController extends BaseController {
  final VoidCallback onUpdate;

  MapOptionsPageController({this.onUpdate});
  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => Padding(
        padding: EdgeInsets.only(right: getDefaultPadding(context) * 2),
        child: InkWell(
          onTap: () => onUpdate(),
          child: Container(
            decoration: BoxDecoration(
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.green,
                borderRadius: BorderRadius.all(Radius.circular(ServiceProvider
                    .instance.instanceStyleService.appStyle.borderRadius))),
            child: Padding(
              padding: EdgeInsets.all(getDefaultPadding(context)),
              child: Center(
                child: Text(
                  "Gå til kart",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.body1
                      .copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => "Finn";
}

class MapOptionsPage extends BaseView {
  final MapOptionsPageController controller;

  MapOptionsPage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.transparent,
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text("data")],
        ),
      ),
    );
  }
}
