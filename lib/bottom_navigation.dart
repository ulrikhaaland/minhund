import 'package:flutter/material.dart';
import 'package:minhund/presentation/home/journal/journal.dart';
import 'package:minhund/presentation/home/leverage/leverage.dart';
import 'package:minhund/presentation/home/map/map.dart';
import 'package:minhund/presentation/home/profile/profile.dart';
import 'package:minhund/presentation/widgets/bottom_nav.dart';
import 'package:minhund/utilities/masterpage.dart';

class BottomNavigationController extends MasterPageController {
  Widget bottomNavigationBar;
  int bottomNavIndex = 0;

  BottomNavigationController({
    this.journal,
    this.mapLocation,
    this.leverage,
    this.profile,
  });

  final Journal journal;
  final MapLocation mapLocation;
  final Leverage leverage;
  final Profile profile;

  final List<Widget> pages = [];
  @override
  void initState() {
    bottomNavigationBar = BottomNav(
      onTabChanged: (index) => setState(() => bottomNavIndex = index),
    );
    pages.addAll(<MasterPage>[
      journal,
      mapLocation,
      leverage,
      profile,
    ]);

    super.initState();
  }

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => bottomNavigationBar;

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => null;

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;
}

class BottomNavigation extends MasterPage {
  final BottomNavigationController controller;

  BottomNavigation({
    this.controller,
  });
  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return IndexedStack(
      index: controller.bottomNavIndex,
      children: controller.pages,
    );
  }
}
