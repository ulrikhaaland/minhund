import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/journal/journal-category/journal_add_category.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_list_item.dart';
import 'package:minhund/presentation/home/journal/journal_page.dart';
import 'package:minhund/presentation/widgets/reorderable_list.dart';
import 'package:minhund/provider/journal_event_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

import 'journal_event_dialog.dart';

abstract class EventActionController {
  Future<void> onEventDelete({JournalEventItem event});

  Future<void> onEventUpdate({JournalEventItem event});

  Future<DocumentReference> onEventCreate({JournalEventItem event});
}

class JournalEventPageController extends MasterPageController
    implements EventActionController {
  final JournalCategoryItem categoryItem;

  List<JournalEventItem> upcomingEvents = [];
  List<JournalEventItem> completedEvents = [];

  final JournalPageController actionController;

  Dog dog;

  User user;

  Color upComingColor = Colors.transparent;

  Color completedColor = Colors.transparent;

  JournalEventPageController({
    this.actionController,
    this.categoryItem,
  });

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => [
        IconButton(
          onPressed: () => showCustomDialog(
              dialogSize: DialogSize.medium,
              context: context,
              child: JournalAddCategory(
                controller: JournalAddCategoryController(
                  actionController: actionController,
                  singleCategoryItem: categoryItem,
                  pageState: PageState.edit,
                ),
              )),
          icon: Icon(Icons.edit),
          color:
              ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
          iconSize: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard,
        )
      ];

  @override
  Widget get bottomNav => null;

  @override
  FloatingActionButton get fab => FloatingActionButton(
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => showCustomDialog(
            context: context,
            child: JournalEventDialog(
              controller: JournalEventDialogController(
                user: user,
                actionController: this,
                parentDocRef: dog.docRef,
                // onDelete: (id) => setState(() => onEventAction(id)),
                pageState: PageState.create,
              ),
            )),
      );

  @override
  String get title => categoryItem.title;

  @override
  void initState() {
    super.initState();

    dog = actionController.dog;
    user = actionController.user;
  }

  void sortItems() {
    if (categoryItem.journalEventItems.isNotEmpty) {
      upcomingEvents = categoryItem.journalEventItems
          .where((item) => item.completed != true)
          .toList();
      completedEvents = categoryItem.journalEventItems
          .where((item) => item.completed == true)
          .toList();
    } else {
      upcomingEvents = [];
      completedEvents = [];
    }

    sortListByDate(eventItemList: completedEvents);
    sortListByDate(eventItemList: upcomingEvents);
  }

  onSaveItem(JournalEventItem item) async {
    sortItems();
    // If item is null a delete item event has occured
    if (item != null) {
      JournalEventItem journalEventItem =
          categoryItem.journalEventItems.firstWhere((i) => i.id == item.id);
      if (journalEventItem == null) {
        categoryItem.journalEventItems.add(item);
      } else {
        int index =
            categoryItem.journalEventItems.indexWhere((j) => j.id == item.id);
        categoryItem.journalEventItems.removeWhere((k) => k.id == item.id);
        categoryItem.journalEventItems.insert(index, item);
        print(categoryItem.journalEventItems[index].title);
      }
      //  Handles sorting on new/updated [JournalEventItem]
      List<JournalEventItem> compare;
      if (item.completed) {
        setState(() => completedColor =
            ServiceProvider.instance.instanceStyleService.appStyle.green);
        await Future.delayed(Duration(milliseconds: 500));
        setState(() => completedColor = Colors.transparent);
        compare = completedEvents;
      } else {
        setState(() => upComingColor =
            ServiceProvider.instance.instanceStyleService.appStyle.green);
        await Future.delayed(Duration(milliseconds: 500));
        setState(() => upComingColor = Colors.transparent);
        compare = upcomingEvents;
      }
      if (compare.isNotEmpty) if (compare[0] != item &&
          (compare[0].timeStamp != null && item.timeStamp != null)) if (item
              .timeStamp
              .isBefore(compare[0].timeStamp) &&
          compare[0].sortIndex != null) {
        item.sortIndex = 0;

        reOrder(compare.indexOf(item), item.sortIndex, compare);
      }
    }
    // onEventAction(null);
    refresh();
  }

  void sortListByDate({@required List<JournalEventItem> eventItemList}) {
    if (eventItemList.isNotEmpty) {
      eventItemList.sort((a, b) {
        if (a.timeStamp != null && b.timeStamp != null)
          return a.timeStamp.compareTo(b.timeStamp);
        else
          return 0;
      });
      eventItemList.sort((a, b) {
        int assortIndex = a.sortIndex ?? eventItemList.length + 1;
        int bssortIndex = b.sortIndex ?? eventItemList.length + 1;

        return assortIndex.compareTo(bssortIndex);
      });
    }
  }

  void reOrder(int oldIndex, int newIndex, List<JournalEventItem> list) {
    JournalEventItem cItem = list.removeAt(oldIndex);

    JournalEventItem oldItem =
        list.firstWhere((i) => i.sortIndex == newIndex, orElse: () => null);

    cItem.sortIndex = newIndex;

    onEventUpdate(event: cItem);

    list.insert(newIndex, cItem);

    if (oldItem != null) {
      oldItem.sortIndex = list.indexOf(oldItem);

      onEventUpdate(event: oldItem);
    }
  }

  @override
  bool get enabledTopSafeArea => null;

  @override
  Future<DocumentReference> onEventCreate({JournalEventItem event}) {
    if (event.timeStamp != null) {
      if (event.timeStamp.isBefore(DateTime.now())) event.completed = true;
    }
    setState(() => categoryItem.journalEventItems.add(event));
    onSaveItem(event);
    event.colorIndex = categoryItem.colorIndex;
    event.categoryId = categoryItem.id;
    actionController.eventItems.add(event);
    actionController.setLatestAndUpcomingEvent();
    return JournalEventProvider()
        .create(model: event, id: categoryItem.docRef.path + "/eventItems");
  }

  @override
  Future<void> onEventDelete({JournalEventItem event}) {
    actionController.eventItems.removeWhere((e) => e.id == event.id);
    actionController.setLatestAndUpcomingEvent();
    if (event.reminder != null)
      Firestore.instance.document("reminders/${event.id}").delete();

    categoryItem.journalEventItems.removeWhere((item) => item.id == event.id);

    Navigator.pop(context);

    setState(() {});

    return JournalEventProvider().delete(model: event);
  }

  @override
  Future<void> onEventUpdate({JournalEventItem event}) {
    actionController.eventItems.removeWhere((i) => i.id == event.id);
    actionController.eventItems.add(event);

    onSaveItem(event);

    actionController.setLatestAndUpcomingEvent();

    return JournalEventProvider().update(model: event);
  }

  @override
  bool get hasBottomNav => false;
}

class JournalEventPage extends MasterPage {
  final JournalEventPageController controller;

  JournalEventPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    controller.sortItems();

    double padding = getDefaultPadding(context);

    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            Container(
              height: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeBig *
                  2,
              child: Card(
                color: Colors.white,
                elevation: ServiceProvider
                    .instance.instanceStyleService.appStyle.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ServiceProvider
                      .instance.instanceStyleService.appStyle.borderRadius),
                ),
                child: LayoutBuilder(
                  builder: (context, con) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          right: 0,
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                                color: controller.upComingColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .borderRadius),
                                    topRight: Radius.circular(ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .borderRadius))),
                            duration: Duration(milliseconds: 1000),
                            height: con.maxHeight,
                            curve: Curves.easeOut,
                            width: con.maxWidth / 2,
                            padding: EdgeInsets.only(top: padding),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                                color: controller.completedColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .borderRadius),
                                    topLeft: Radius.circular(ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .borderRadius))),
                            duration: Duration(milliseconds: 1000),
                            height: con.maxHeight,
                            curve: Curves.easeOut,
                            width: con.maxWidth / 2,
                            padding: EdgeInsets.only(top: padding),
                          ),
                        ),
                        TabBar(
                          indicatorColor: ServiceProvider
                              .instance.instanceStyleService.appStyle.skyBlue,
                          indicatorWeight: 3,
                          indicatorPadding: EdgeInsets.only(
                            left: padding * 4,
                            right: padding * 4,
                            bottom: padding,
                          ),
                          tabs: <Widget>[
                            Container(
                              height: ServiceProvider
                                      .instance
                                      .instanceStyleService
                                      .appStyle
                                      .iconSizeStandard *
                                  2,
                              padding: EdgeInsets.only(top: padding),
                              child: Tab(
                                icon: Icon(
                                  Icons.check,
                                  color: ServiceProvider.instance
                                      .instanceStyleService.appStyle.green,
                                  size: ServiceProvider
                                      .instance
                                      .instanceStyleService
                                      .appStyle
                                      .iconSizeBig,
                                ),
                                // child: Column(
                                //   children: <Widget>[
                                //     Icon(
                                //       Icons.check,
                                //       color: ServiceProvider
                                //           .instance.instanceStyleService.appStyle.green,
                                //       size: ServiceProvider
                                //           .instance
                                //           .instanceStyleService
                                //           .appStyle
                                //           .iconSizeStandard,
                                //     ),
                                //     // Text(
                                //     //   "Fullførte",
                                //     //   style: ServiceProvider.instance
                                //     //       .instanceStyleService.appStyle.descTitle,
                                //     // ),
                                //   ],
                                // ),
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.timer,
                                color: ServiceProvider.instance
                                    .instanceStyleService.appStyle.imperial,
                                size: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .iconSizeStandard,
                              ),
                              // child: Column(
                              //   children: <Widget>[
                              //     Icon(
                              //       Icons.timer,
                              //       color: ServiceProvider.instance
                              //           .instanceStyleService.appStyle.imperial,
                              //       size: ServiceProvider
                              //           .instance
                              //           .instanceStyleService
                              //           .appStyle
                              //           .iconSizeStandard,
                              //     ),
                              //     Text(
                              //       "Kommende",
                              //       style: ServiceProvider.instance
                              //           .instanceStyleService.appStyle.descTitle,
                              //     ),
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                key: UniqueKey(),
                children: <Widget>[
                  ReorderableList(
                    onReorder: (oldIndex, newIndex) => controller.reOrder(
                        oldIndex, newIndex, controller.completedEvents),
                    widgetList: controller.completedEvents
                        .map(
                          (item) => JournalEventListItem(
                            key: Key(item.id ??
                                Random().nextInt(99999999).toString()),
                            controller: JournalEventListItemController(
                              user: controller.user,
                              categoryItem: controller.categoryItem,
                              actionController: controller,
                              dog: controller.dog,
                              eventItem: item,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ReorderableList(
                    onReorder: (oldIndex, newIndex) => controller.reOrder(
                        oldIndex, newIndex, controller.upcomingEvents),
                    widgetList: controller.upcomingEvents
                        .map(
                          (item) => JournalEventListItem(
                            key: UniqueKey(),
                            controller: JournalEventListItemController(
                              user: controller.user,
                              categoryItem: controller.categoryItem,
                              dog: controller.dog,
                              actionController: controller,
                              eventItem: item,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
