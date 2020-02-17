import 'package:flutter/material.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class UserProfileController extends BaseController {
  final User user;

  UserProfileController({this.user});
}

class UserProfile extends BaseView {
  final UserProfileController controller;

  UserProfile({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return Column(
      children: <Widget>[],
    );
  }
}
