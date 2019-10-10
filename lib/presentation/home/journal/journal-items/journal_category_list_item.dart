import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_list_item.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:provider/provider.dart';

class JournalCategoryListItemController extends BaseController {
  final JournalCategoryItem item;

  final Dog dog;

  bool expanded = false;

  JournalCategoryListItemController({this.item, this.dog});

  @override
  void initState() {
    if (item.journalEventItems == null) item.journalEventItems = [];
    super.initState();
  }
}

class JournalCategoryListItem extends BaseView {
  final JournalCategoryListItemController controller;

  JournalCategoryListItem({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return LayoutBuilder(
      builder: (context, con) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalEventPage(
                  controller: JournalEventPageController(
                    categoryItem: controller.item,
                    dog: controller.dog,
                    onUpdate: () => controller.setState(() {}),
                  ),
                ),
              )),
          child: Column(
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
                      icon:
                          Icon(controller.expanded ? Icons.remove : Icons.add),
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
                      return JournalEventListItem(
                          key: Key(controller.item.journalEventItems[index].id),
                          controller: JournalEventListItemController(
                              eventItem:
                                  controller.item.journalEventItems[index]));
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
          ),
        );
      },
    );
  }
}
