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
            Container(
              height: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeStandard *
                  1.5,
              width: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeStandard *
                  1.5,
              decoration: BoxDecoration(
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.green,
                borderRadius: BorderRadius.all(Radius.circular(ServiceProvider
                        .instance.instanceStyleService.appStyle.borderRadius -
                    3)),
              ),
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () => showCustomDialog(
                      context: context,
                      child: JournalListItemEvent(
                        controller: JournalListItemEventController(
                          title: controller.item.title,
                          eventItem: JournalEventItem(),
                        ),
                      )),
                  iconSize: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeSmall,
                ),
              ),
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
          Container(),
        ],
      ],
    );
  }
}
