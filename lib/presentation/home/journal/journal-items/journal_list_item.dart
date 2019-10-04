import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_list_item_event.dart';
import 'package:minhund/service/service_provider.dart';

class JournalListItemController extends BaseController {
  final JournalItem item;

  bool expanded = false;

  JournalListItemController({this.item});

  @override
  void initState() {
    if (item.journalEventItems == null) item.journalEventItems = [];
    super.initState();
  }
}

class JournalListItem extends BaseView {
  final JournalListItemController controller;

  JournalListItem({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return LayoutBuilder(
      builder: (context, con) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 5),
              child: Row(
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
                    icon: Icon(controller.expanded ? Icons.remove : Icons.add),
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.textGrey,
                    onPressed: () => controller.setState(
                        () => controller.expanded = !controller.expanded),
                    iconSize: ServiceProvider
                        .instance.instanceStyleService.appStyle.iconSizeSmall,
                  ),
                ],
              ),
            ),
            Divider(),
            if ((controller.item.journalEventItems != null &&
                    controller.item.journalEventItems.isNotEmpty) &&
                controller.expanded) ...[
              Container(
                height: getListItemHeight(context),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: controller.item.journalEventItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                      ],
                    );
                    // JournalListItemEvent();
                  },
                ),
              ),
            ] else if (controller.expanded) ...[
              Text(
                "Her var det tomt gitt...",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.body1,
              ),
            ]
          ],
        );
      },
    );
  }
}
