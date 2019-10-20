import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';
import 'journal_event_dialog.dart';

class JournalEventListItemController extends BaseController {
  final JournalEventItem eventItem;

  final void Function(JournalEventItem eventItem) onChanged;

  final Dog dog;

  final User user;

  final JournalCategoryItem categoryItem;

  JournalEventListItemController(
      {this.eventItem, this.onChanged, this.dog, this.categoryItem, this.user});
}

class JournalEventListItem extends BaseView {
  final Key key;
  final JournalEventListItemController controller;

  JournalEventListItem({this.controller, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCustomDialog(
        context: context,
        child: JournalEventDialog(
          controller: JournalEventDialogController(
            user: controller.user,
            onSave: (item) => controller.onChanged(item),
            eventItem: controller.eventItem,
            categoryItem: controller.categoryItem,
            parentDocRef: controller.dog.docRef,
            pageState: PageState.read,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: getDefaultPadding(context),
            right: getDefaultPadding(context),
            top: getDefaultPadding(context)),
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
                Flexible(
                  child: Text(
                    controller.eventItem.title,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.smallTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: ServiceProvider
                            .instance.instanceStyleService.appStyle.green,
                        value: controller.eventItem.completed,
                        onChanged: (val) async {
                          controller.eventItem.completed = val;
                          controller.setState(() {});
                          await Future.delayed(Duration(milliseconds: 250));
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
      ),
    );
  }
}
