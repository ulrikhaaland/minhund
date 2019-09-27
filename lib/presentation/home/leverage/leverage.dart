import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/utilities/masterpage.dart';

import '../../../bottom_navigation.dart';

class LeverageController extends MasterPageController {
  LeverageController();

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => "Fordelsprogram";

  @override
  // TODO: implement bottomNavigationBar
  Widget get bottomNavigationBar => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;
}

class Leverage extends MasterPage {
  final LeverageController controller;

  Leverage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Text("bottomNavigationBar: controller.bottomNav,");
  }
}
