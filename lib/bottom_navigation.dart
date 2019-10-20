import 'package:flutter/material.dart';
import 'package:minhund/presentation/home/journal/journal_page.dart';
import 'package:minhund/presentation/home/leverage/leverage.dart';
import 'package:minhund/presentation/home/map/map_page.dart';
import 'package:minhund/presentation/home/profile/profile.dart';
import 'package:minhund/presentation/widgets/bottom_nav.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/utilities/master_page.dart';

import 'model/user.dart';

class BottomNavigationController extends MasterPageController {
  Widget bottomNavigationBar;
  int bottomNavIndex = 0;

  final User user;

  BottomNavigationController({this.user});

  JournalPage journal;
  MapPage mapLocation;
  Leverage leverage;
  ProfilePage profile;

  List<BottomNavigation> pages;
  @override
  void initState() {
    bottomNavigationBar = BottomNav(
      onTabChanged: (index) {
        bottomNavIndex = index;
        refresh();
      },
    );
    journal = JournalPage(
      controller: JournalPageController(
        user: user,
      ),
    );
    mapLocation = MapPage(
      controller: MapPageController(),
    );
    profile = ProfilePage(
      controller: ProfilePageController(),
    );
    leverage = Leverage(
      controller: LeverageController(),
    );
    pages = [journal, mapLocation, leverage, profile];
    super.initState();
  }

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;

  @override
  Widget get bottomNav => bottomNavigationBar;

  @override
  String get title => null;

  @override
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
    if (controller.user.dog.profileImage == null) {
      controller.user.dog.profileImage = CustomImage(
        controller: CustomImageController(
          customImageType: CustomImageType.circle,
          imgUrl: controller.user.dog.imgUrl,
        ),
      );
    } else {
      controller.user.dog.profileImage.controller.init = false;
    }
    return IndexedStack(
      index: controller.bottomNavIndex,
      children: controller.pages,
    );
  }
}
