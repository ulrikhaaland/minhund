import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class JournalAppBarController extends BaseController {}

class JournalAppBar extends BaseView {
  final JournalAppBarController controller;

  JournalAppBar({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Row(
      children: <Widget>[
        Expanded(child: Column()),
        CircleAvatar(
          backgroundImage: AdvancedNetworkImage(
              "https://i.ytimg.com/vi/3ggIHfwkIWM/maxresdefault.jpg"),
        ),
      ],
    );
  }
}
