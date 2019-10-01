import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';

class BottomNav extends StatefulWidget {
  final Function(int index) onTabChanged;

  const BottomNav({Key key, this.onTabChanged}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return FancyBottomNavigation(
      barBackgroundColor: Colors.white,
      circleColor:
          ServiceProvider.instance.instanceStyleService.appStyle.skyBlue,
      activeIconColor: Colors.white,
      inactiveIconColor: ServiceProvider
          .instance.instanceStyleService.appStyle.inactiveIconColor,
      onTabChangedListener: (tab) => widget.onTabChanged(tab),
      tabs: [
        TabData(
          title: "",
          iconData: Icons.description,
        ),
        TabData(
          title: "",
          iconData: Icons.map,
        ),
        TabData(
          title: "",
          iconData: Icons.store,
        ),
        TabData(
          title: "",
          iconData: Icons.person_outline,
        ),
      ],
    );
  }
}