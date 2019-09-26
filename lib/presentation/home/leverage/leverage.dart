import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class LeverageController extends BaseController {
  final Widget bottomNav;

  LeverageController({this.bottomNav});
}

class Leverage extends BaseView {
  final LeverageController controller;

  Leverage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Scaffold(
      bottomNavigationBar: controller.bottomNav,
    );
  }
}
