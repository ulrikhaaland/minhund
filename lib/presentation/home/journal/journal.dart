import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/bottom_nav.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

import '../../../bottom_navigation.dart';

class JournalController extends BottomNavigationController {
  JournalController();

  @override
  FloatingActionButton get fab => FloatingActionButton(
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => print("open dialog"),
      );

  @override
  // TODO: implement title
  String get title => "Broren";

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;
}

class Journal extends BottomNavigation {
  final JournalController controller;

  Journal({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Center(child: TextField());
  }
}
