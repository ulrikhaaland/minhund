import 'package:flutter/material.dart';
import '../../../bottom_navigation.dart';

class MapLocationController extends BottomNavigationController {
  MapLocationController();

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => null;

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;
}

class MapLocation extends BottomNavigation {
  final MapLocationController controller;

  MapLocation({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Center(child: Text(" bottomNavigationBar: controller.bottomNav,"));
  }
}
