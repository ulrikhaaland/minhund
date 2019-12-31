import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_page.dart';
import 'package:minhund/presentation/home/journal/journal_page.dart';
import 'package:minhund/provider/journal_event_provider.dart';
import 'package:minhund/service/service_provider.dart';

class JournalCategoryListItemController extends BaseController {
  final JournalCategoryItem categoryItem;

  Dog dog;

  final VoidCallback onUpdate;

  final JournalPageController actionController;

  User user;

  final void Function(
    JournalEventItem next,
    JournalEventItem completed,
    int colorIndex,
  ) returnLatest;

  final void Function(String deletedId) returnDeletedId;

  bool isLoading = true;

  JournalCategoryListItemController(
      {this.categoryItem,
      this.actionController,
      this.onUpdate,
      this.returnLatest,
      this.returnDeletedId});

  @override
  void initState() {
    if (categoryItem.journalEventItems == null)
      categoryItem.journalEventItems = [];
    if (categoryItem.docRef != null) getEvents();

    dog = actionController.dog;
    user = actionController.user;

    super.initState();
  }

  Future<void> getEvents() async {
    categoryItem.journalEventItems = await JournalEventProvider()
        .getCollection(id: categoryItem.docRef.path);

    // findLatestEvent(null);
    if (actionController.eventItems.isNotEmpty)
      actionController.eventItems
          .removeWhere((i) => i.categoryId == categoryItem.id);

    actionController.eventItems.addAll(categoryItem.journalEventItems);

    actionController.setLatestAndUpcomingEvent();

    setState(() {
      isLoading = false;
    });
  }
}

class JournalCategoryListItem extends BaseView {
  final JournalCategoryListItemController controller;

  final Key key;

  JournalCategoryListItem({this.controller, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!mounted || controller.isLoading) return Container();
    return LayoutBuilder(
      builder: (context, con) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalEventPage(
                  controller: JournalEventPageController(
                    actionController: controller.actionController,
                    categoryItem: controller.categoryItem,
                    // dog: controller.dog,
                    // onUpdate: (refreshParent) {
                    //   if (refreshParent) {
                    //     controller.onUpdate();
                    //   } else {
                    //     controller.setState(() {});
                    //   }
                    // },
                    // onEventAction: (id) => controller.findLatestEvent(id),
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
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: ServiceProvider.instance
                                    .instanceStyleService.appStyle.palette[
                                controller.categoryItem.colorIndex ?? 0],
                            radius: con.maxWidth / 30,
                          ),
                          Container(
                            width: getDefaultPadding(context) * 2,
                          ),
                          Flexible(
                            child: Text(
                              controller.categoryItem.title,
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.smallTitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        controller.categoryItem.journalEventItems
                                    .where((item) => item.completed == false)
                                    .length ==
                                0
                            ? ""
                            : controller.categoryItem.journalEventItems
                                    .where((item) => item.completed == false)
                                    .length
                                    .toString() ??
                                "",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
