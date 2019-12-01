import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_page.dart';
import 'package:minhund/provider/journal_event_provider.dart';
import 'package:minhund/service/service_provider.dart';

class JournalCategoryListItemController extends BaseController {
  final JournalCategoryItem item;

  final Dog dog;

  final VoidCallback onUpdate;

  final User user;

  final void Function(
          JournalEventItem item, int colorIndex, String deletedEventId)
      returnLatest;

  bool isLoading = true;

  JournalCategoryListItemController(
      {this.item, this.dog, this.onUpdate, this.user, this.returnLatest});

  @override
  void initState() {
    if (item.journalEventItems == null) item.journalEventItems = [];
    getEvents();

    super.initState();
  }

  Future<void> getEvents() async {
    item.journalEventItems =
        await JournalEventProvider().getCollection(id: item.docRef.path);

    findLatestEvent(null);

    setState(() {
      isLoading = false;
    });
  }

  findLatestEvent(String deletedItemId) {
    if (item.journalEventItems.isNotEmpty) {
      List<JournalEventItem> upcoming =
          item.journalEventItems.where((i) => i.completed != true).toList();
      upcoming.sort((a, b) {
        DateTime dateTimeA = a.timeStamp ?? DateTime(2050);
        DateTime dateTimeB = b.timeStamp ?? DateTime(2050);

        return dateTimeA.compareTo(dateTimeB);
      });

      returnLatest(upcoming[0], item.colorIndex, deletedItemId);
    }
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
                    user: controller.user,
                    categoryItem: controller.item,
                    dog: controller.dog,
                    onUpdate: (refreshParent) {
                      if (refreshParent) {
                        controller.onUpdate();
                      } else {
                        controller.setState(() {});
                      }
                    },
                    onEventAction: (id) => controller.findLatestEvent(id),
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
                            backgroundColor: ServiceProvider
                                .instance
                                .instanceStyleService
                                .appStyle
                                .palette[controller.item.colorIndex ?? 0],
                            radius: con.maxWidth / 30,
                          ),
                          Container(
                            width: getDefaultPadding(context) * 2,
                          ),
                          Flexible(
                            child: Text(
                              controller.item.title,
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
                        controller.item.journalEventItems
                                    .where((item) => item.completed == false)
                                    .length ==
                                0
                            ? ""
                            : controller.item.journalEventItems
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
