import 'package:flutter/material.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

import 'journal_list_item.dart';

class JournalItemsController extends BaseController {
  final List<JournalItem> journalItems;

  JournalItemsController({this.journalItems});
}

class JournalItemsPage extends BaseView {
  final JournalItemsController controller;

  JournalItemsPage({this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ServiceProvider.instance.instanceStyleService.appStyle.lightBlue,
      child: Column(
        children: controller.journalItems != null
            ? controller.journalItems.map((item) {
                return JournalListItem(
                  controller: JournalListItemController(item: item),
                );
              }).toList()
            : [
                Container(),
              ],
      ),
    );
  }
}
