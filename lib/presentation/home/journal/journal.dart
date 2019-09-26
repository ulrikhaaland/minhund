import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class JournalController extends BaseController {
  final Widget bottomNav;

  JournalController({this.bottomNav});
}

class Journal extends BaseView {
  final JournalController controller;

  Journal({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Scaffold(
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      body: Center(
        child: Text(
          "Hello WOrld",
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: controller.bottomNav,
    );
  }
}
