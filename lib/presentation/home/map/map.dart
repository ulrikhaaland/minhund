import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/utilities/masterpage.dart';

import '../../../bottom_navigation.dart';

class MapLocationController extends MasterPageController {
  MapLocationController();

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;
}

class MapLocation extends MasterPage {
  final MapLocationController controller;

  MapLocation({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Center(child: Text(" bottomNavigationBar: controller.bottomNav,"));
  }
}
