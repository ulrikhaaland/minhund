import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/journal/journal.dart';
import 'package:minhund/presentation/home/leverage/leverage.dart';
import 'package:minhund/presentation/home/map/map_location.dart';
import 'package:minhund/presentation/home/profile/profile.dart';
import 'package:minhund/presentation/widgets/bottom_nav.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class BottomNavigationController extends MasterPageController {
  Widget bottomNavigationBar;
  int bottomNavIndex = 0;

  BottomNavigationController();

  Journal journal;
  MapLocation mapLocation;
  Leverage leverage;
  Profile profile;

  List<BottomNavigation> pages;
  @override
  void initState() {
    bottomNavigationBar = BottomNav(
      onTabChanged: (index) {
        bottomNavIndex = index;
        refresh();
      },
    );
    journal = Journal(
      controller: JournalController(),
    );
    mapLocation = MapLocation(
      controller: MapLocationController(),
    );
    profile = Profile(
      controller: ProfileController(),
    );
    leverage = Leverage(
      controller: LeverageController(),
    );
    pages = [journal, mapLocation, leverage, profile];
    super.initState();
  }

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => bottomNavigationBar;

  @override
  // TODO: implement title
  String get title => null;

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;
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
