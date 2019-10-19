import 'package:flutter/material.dart';
import '../../../bottom_navigation.dart';

class ProfilePageController extends BottomNavigationController {
  ProfileController() {
    print("Profile Page built");
  }

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Profil";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;
}

class ProfilePage extends BottomNavigation {
  final ProfilePageController controller;

  ProfilePage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Center(child: Text(" bottomNavigationBar: controller.bottomNav,"));
  }
}
