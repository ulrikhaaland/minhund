import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class MapLocationController extends BaseController {
  final Widget bottomNav;

  MapLocationController({this.bottomNav});
}

class MapLocation extends BaseView {
  final MapLocationController controller;

  MapLocation({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Scaffold(
      bottomNavigationBar: controller.bottomNav,
    );
  }
}
