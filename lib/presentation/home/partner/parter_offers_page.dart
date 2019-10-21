import 'package:flutter/material.dart';
import 'package:minhund/bottom_navigation.dart';

class PartnerOffersPageController extends BottomNavigationController {}

class PartnerOffersPage extends BottomNavigation {
  final PartnerOffersPageController controller;

  PartnerOffersPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    return Container();
  }
}
