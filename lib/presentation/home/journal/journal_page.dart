import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/journal/journal-category/journal_add_category.dart';
import 'package:minhund/presentation/widgets/reorderable_list.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';
import 'journal-category/journal_category_list_item.dart';
import 'journal-event/journal_event_dialog.dart';

class JournalPageController extends MasterPageController {
  static final JournalPageController _instance =
      JournalPageController._internal();

  factory JournalPageController() {
    return _instance;
  }

  JournalPageController._internal() {
    print("Journal Page built");
  }

  List<JournalEventItem> nextEvents = [];
  List<JournalEventItem> completedEvents = [];

  User user;

  Dog dog;

  bool isLoading = true;

  int nextEventColorIndex = 0;
  int completedEventColorIndex = 0;

  List<JournalCategoryListItemController> categoryControllers = [];

  @override
  void initState() {
    Timer.periodic(Duration(minutes: 10), (_) {
      categoryControllers.forEach((c) => c.findLatestEvent(null));
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  FloatingActionButton get fab => FloatingActionButton(
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => showCustomDialog(
          dialogSize: DialogSize.medium,
          context: context,
          child: JournalAddCategory(
            controller: JournalAddCategoryController(
              journalCategoryItems: dog.journalItems,
              childOnSaved: () => null,
              dogDocRefPath: dog.docRef.path,
              pageState: PageState.create,
            ),
          ),
        ),
      );

  @override
  String get title => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get bottomNav => null;

  @override
  List<Widget> get actionTwoList => null;

  void getJournalItems() {
    user.dogs.forEach((dog) async {
      dog.journalItems =
          await JournalProvider().getCollection(id: dog.docRef.path);
      setState(() {});
    });
    isLoading = false;
  }

  getLatestEvent(
      {JournalEventItem nextItem,
      JournalEventItem completedItem,
      int colorIndex,
      String deletedEventId}) {
    if (nextItem == null && completedItem == null) if (deletedEventId != null) {
      if (nextEvents.firstWhere((j) => j.id == deletedEventId,
              orElse: () => null) !=
          null) {
        nextEvents.removeWhere((j) => j.id == deletedEventId);
      }
      if (completedEvents.firstWhere((j) => j.id == deletedEventId,
              orElse: () => null) !=
          null) {
        completedEvents.removeWhere((j) => j.id == deletedEventId);
      }
    }

    if (nextItem != null) {
      JournalEventItem oldItem =
          nextEvents.firstWhere((i) => i.id == nextItem.id, orElse: () => null);
      if (oldItem != null) {
        nextEvents.remove(oldItem);
      }

      nextEvents.add(nextItem);
      nextEvents.removeWhere((j) => j.timeStamp?.isBefore(DateTime.now()));
    }
    if (nextEvents.isNotEmpty) {
      nextEvents.sort((a, b) {
        DateTime dateTimeA = a.timeStamp ?? DateTime(2050);
        DateTime dateTimeB = b.timeStamp ?? DateTime(2050);

        return dateTimeA.compareTo(dateTimeB);
      });
      if (nextItem == nextEvents[0]) nextEventColorIndex = colorIndex;
    }
    if (completedItem != null) {
      JournalEventItem oldItem = completedEvents
          .firstWhere((i) => i.id == completedItem.id, orElse: () => null);
      if (oldItem != null) {
        completedEvents.remove(oldItem);
      }

      completedEvents.add(completedItem);
      completedEvents.removeWhere((j) => j.timeStamp?.isAfter(DateTime.now()));
    }
    if (completedEvents.isNotEmpty) {
      completedEvents.sort((a, b) {
        DateTime dateTimeA = a.timeStamp ?? DateTime(2050);
        DateTime dateTimeB = b.timeStamp ?? DateTime(2050);

        return dateTimeB.compareTo(dateTimeA);
      });
      if (completedItem == completedEvents[0])
        completedEventColorIndex = colorIndex;
    }

    setState(() {});
  }
}

class JournalPage extends MasterPage {
  final JournalPageController controller;

  JournalPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.user == null) controller.user = Provider.of<User>(context);

    controller.dog = controller.user.dog;
    controller.dog.profileImage.controller.imageSizePercentage = 10;
    controller.dog.profileImage.controller.edit = false;
    if (controller.isLoading) controller.getJournalItems();

    getTimeDifference(time: controller.dog.birthDate, daysMonthsYears: true);

    return Container(
      padding: EdgeInsets.only(
          left: getDefaultPadding(context) * 2,
          right: getDefaultPadding(context) * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Card(
              color: Colors.white,
              elevation: ServiceProvider
                  .instance.instanceStyleService.appStyle.elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ServiceProvider
                    .instance.instanceStyleService.appStyle.borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(getDefaultPadding(context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              controller.dog.name,
                              style: ServiceProvider
                                  .instance.instanceStyleService.appStyle.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${controller.dog.race}, ${formatDifference(date2: controller.dog.birthDate, date1: DateTime.now())}, ${controller.dog.weigth} kilo",
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.body1,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                    controller.user.dog.profileImage
                  ],
                ),
              ),
            ),
          ),
          if (controller.nextEvents.isNotEmpty)
            InkWell(
              onTap: () => showCustomDialog(
                context: context,
                child: JournalEventDialog(
                  controller: JournalEventDialogController(
                    user: controller.user,
                    canEdit: false,
                    eventItem: controller.nextEvents[0],
                    pageState: PageState.read,
                  ),
                ),
              ),
              child: Card(
                color: Colors.white,
                elevation: ServiceProvider
                    .instance.instanceStyleService.appStyle.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ServiceProvider
                      .instance.instanceStyleService.appStyle.borderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.all(getDefaultPadding(context)),
                  child: RichText(
                    key: Key(controller.nextEvents[0].timeStamp.toString()),
                    overflow: TextOverflow.clip,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Neste: ",
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.italic),
                      TextSpan(
                          text: controller.nextEvents[0].title,
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.body1
                              .copyWith(
                                  color: ServiceProvider
                                          .instance
                                          .instanceStyleService
                                          .appStyle
                                          .palette[
                                      controller.nextEventColorIndex])),
                      if (controller.nextEvents[0].timeStamp != null)
                        TextSpan(
                            text: " " +
                                formatDifference(
                                    date2: DateTime.now(),
                                    date1: controller.nextEvents[0].timeStamp,
                                    futureString: true),
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.italic),
                    ]),
                  ),
                ),
              ),
            ),
          if (controller.completedEvents.isNotEmpty)
            InkWell(
              onTap: () => showCustomDialog(
                context: context,
                child: JournalEventDialog(
                  controller: JournalEventDialogController(
                    user: controller.user,
                    canEdit: false,
                    eventItem: controller.completedEvents[0],
                    pageState: PageState.read,
                  ),
                ),
              ),
              child: Card(
                color: Colors.white,
                elevation: ServiceProvider
                    .instance.instanceStyleService.appStyle.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ServiceProvider
                      .instance.instanceStyleService.appStyle.borderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.all(getDefaultPadding(context)),
                  child: RichText(
                    key:
                        Key(controller.completedEvents[0].timeStamp.toString()),
                    overflow: TextOverflow.clip,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Siste: ",
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.italic),
                      TextSpan(
                          text: controller.completedEvents[0].title,
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.body1
                              .copyWith(
                                  color: ServiceProvider
                                          .instance
                                          .instanceStyleService
                                          .appStyle
                                          .palette[
                                      controller.completedEventColorIndex])),
                      if (controller.completedEvents[0].timeStamp != null)
                        TextSpan(
                            text: " " +
                                formatDifference(
                                    date2: DateTime.now(),
                                    date1:
                                        controller.completedEvents[0].timeStamp,
                                    futureString: false),
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.italic),
                    ]),
                  ),
                ),
              ),
            ),
          Container(
            height: getDefaultPadding(context) * 4,
          ),
          if (controller.dog.journalItems != null)
            Flexible(
              flex: 4,
              child: ReorderableList(
                  onReorder: (oldIndex, newIndex) {
                    JournalCategoryItem cItem =
                        controller.dog.journalItems.removeAt(oldIndex);

                    JournalCategoryItem oldItem = controller.dog.journalItems
                        .firstWhere((i) => i.sortIndex == newIndex,
                            orElse: () => null);

                    cItem.sortIndex = newIndex;

                    JournalProvider().update(model: cItem);

                    controller.dog.journalItems.insert(newIndex, cItem);

                    if (oldItem != null) {
                      oldItem.sortIndex =
                          controller.dog.journalItems.indexOf(oldItem);

                      JournalProvider().update(model: oldItem);
                    }
                  },
                  widgetList: controller.dog.journalItems.map((item) {
                    JournalCategoryListItemController ctrlr =
                        JournalCategoryListItemController(
                            returnLatest:
                                (nextItem, completedItem, colorIndex) =>
                                    controller.getLatestEvent(
                                        nextItem: nextItem,
                                        completedItem: completedItem,
                                        colorIndex: colorIndex),
                            returnDeletedId: (id) =>
                                controller.getLatestEvent(deletedEventId: id),
                            user: controller.user,
                            onUpdate: () => controller.setState(() {}),
                            dog: controller.dog,
                            item: item);

                    if (controller.categoryControllers.isNotEmpty)
                      controller.categoryControllers
                          .removeWhere((c) => c.item.id == ctrlr.item.id);

                    controller.categoryControllers.add(ctrlr);
                    return JournalCategoryListItem(
                        key: Key(item.id), controller: ctrlr);
                  }).toList()),
            ),
        ],
      ),
    );
  }
}
