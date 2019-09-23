import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class JournalController extends BaseController {}

class Journal extends BaseView {
  final JournalController controller;

  Journal({this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      body: Text("Hello WOrld"),
    );
  }
}
