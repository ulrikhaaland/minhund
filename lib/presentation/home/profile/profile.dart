import 'package:flutter/material.dart';
import '../../../bottom_navigation.dart';

class ProfileController extends BottomNavigationController {
  ProfileController();
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

class Profile extends BottomNavigation {
  final ProfileController controller;

  Profile({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Center(child: Text(" bottomNavigationBar: controller.bottomNav,"));
  }
}
