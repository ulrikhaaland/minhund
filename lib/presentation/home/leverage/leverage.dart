import 'package:flutter/material.dart';
import '../../../bottom_navigation.dart';

class LeverageController extends BottomNavigationController {
  LeverageController();

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Fordelsprogram";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;
}

class Leverage extends BottomNavigation {
  final LeverageController controller;

  Leverage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Text("bottomNavigationBar: controller.bottomNav,");
  }
}
