import 'package:flutter/material.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class JournalListItemController extends BaseController {
  final JournalItem item;

  JournalListItemController({this.item});
}

class JournalListItem extends BaseView {
  final JournalListItemController controller;

  JournalListItem({this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          controller.item.title,
          style: ServiceProvider.instance.instanceStyleService.appStyle.title,
        ),
        Divider(),
      ],
    );
  }
}
