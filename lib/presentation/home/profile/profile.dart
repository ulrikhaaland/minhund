import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class ProfileController extends BaseController {
  final Widget bottomNav;

  ProfileController({this.bottomNav});
}

class Profile extends BaseView {
  final ProfileController controller;

  Profile({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Scaffold(
      bottomNavigationBar: controller.bottomNav,
    );
  }
}
