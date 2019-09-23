import 'package:minhund/service/screen_service.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestController extends MasterPageController {
  @override
  // TODO: implement actions
  List<Widget> get actions => null;

  @override
  // TODO: implement asWorkflow
  bool get asWorkflow => false;

  @override
  // TODO: implement bottomTabs
  List<DetailTab> get bottomTabs => null;

  @override
  // TODO: implement detailTabs
  List<DetailTab> get detailTabs => null;

  @override
  // TODO: implement floatingActionButton
  IconButton get floatingActionButton => null;

  @override
  // TODO: implement title
  String get title => "TITLE";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class Test extends MasterPage {
  final TestController controller;

  Test({@required this.controller});

  @override
  Widget buildContentLandscape(
      BuildContext context, ScreenSizeDefinition screenSizeDefinition) {
    // TODO: implement buildContentLandscape
    return _build(context, screenSizeDefinition);
  }

  @override
  Widget buildContentPortrait(
      BuildContext context, ScreenSizeDefinition screenSizeDefinition) {
    // TODO: implement buildContentPortrait
    return _build(context, screenSizeDefinition);
  }

  Widget _build(
    BuildContext context,
    ScreenSizeDefinition screenSizeDefinition, {
    bool landscape = false,
  }) {
    if (!mounted) {
      return Container();
    }
    return Scaffold(
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.pink,
    );
  }
}
