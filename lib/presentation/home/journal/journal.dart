import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/masterpage.dart';

import '../../../bottom_navigation.dart';

class JournalController extends MasterPageController {
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
  String get title => "Hund";

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;
}

class Journal extends MasterPage {
  final JournalController controller;

  Journal({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Center(child: TextField());
  }
}
