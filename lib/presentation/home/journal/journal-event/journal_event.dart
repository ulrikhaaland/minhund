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

class JournalEventController extends BaseController {
  final JournalEventItem eventItem;

  JournalEventController({this.eventItem});
}

class JournalEvent extends BaseView {
  final JournalEventController controller;

  JournalEvent({this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCustomDialog(
          context: context,
          child: JournalEventDialog(
            controller: JournalEventDialogController(
              eventItem: controller.eventItem,
              journalItems: Provider.of<Dog>(context).journalItems,
            ),
          )),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ServiceProvider
              .instance.instanceStyleService.appStyle.borderRadius),
        ),
        child: Padding(
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
              Text(
                controller.eventItem.title,
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.smallTitle,
              ),
              // Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
