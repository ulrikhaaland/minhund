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
    if (!mounted) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                controller.item.title,
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => null,
            ),
          ],
        ),
        Divider(),
        if (controller.item.journalEventItems != null) ...[
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.item.journalEventItems.length,
            itemBuilder: (context, index) {
              return Text("data");
              // JournalListItemEvent();
            },
          ),
        ] else ...[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => null,
          ),
        ],
      ],
    );
  }
}
