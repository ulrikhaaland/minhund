import 'package:flutter/material.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'journal-category/journal_category_list_item.dart';

class JournalItemsController extends BaseController {
  final List<JournalCategoryItem> journalItems;

  JournalItemsController({this.journalItems});
}

class JournalItemsPage extends BaseView {
  final JournalItemsController controller;

  JournalItemsPage({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    if (controller.journalItems != null)
      return Column(
          children: controller.journalItems.map((item) {
        return JournalCategoryListItem(
          controller: JournalCategoryListItemController(item: item),
        );
      }).toList());

    return Container();
  }
}
