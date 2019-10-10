import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:provider/provider.dart';

import 'journal_event_dialog.dart';

class JournalEventListItemController extends BaseController {
  final JournalEventItem eventItem;

  final void Function(JournalEventItem eventItem) onChanged;

  final Dog dog;

  JournalEventListItemController({this.eventItem, this.onChanged, this.dog});
}

class JournalEventListItem extends BaseView {
  final Key key;
  final JournalEventListItemController controller;

  JournalEventListItem({this.controller, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getDefaultPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            formatDate(
                  date: controller.eventItem.timeStamp,
                ) ??
                "Ingen dato satt",
            style: ServiceProvider
                .instance.instanceStyleService.appStyle.timestamp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                controller.eventItem.title,
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.smallTitle,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: ServiceProvider.instance.instanceStyleService
                        .appStyle.iconSizeStandard,
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.textGrey,
                    onPressed: () => showCustomDialog(
                      context: context,
                      child: JournalEventDialog(
                        controller: JournalEventDialogController(
                          onSave: (item) => controller.onChanged(null),
                          eventItem: controller.eventItem,
                          journalItems: controller.dog.journalItems,
                          parentDocRef: controller.dog.docRef,
                          pageState: PageState.read,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: getDefaultPadding(context) * 4,
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: ServiceProvider
                          .instance.instanceStyleService.appStyle.green,
                      value: controller.eventItem.completed,
                      onChanged: (val) {
                        controller.eventItem.completed = val;
                        controller.onChanged(controller.eventItem);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
