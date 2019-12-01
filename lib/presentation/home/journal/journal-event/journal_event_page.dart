import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/journal/journal-category/journal_add_category.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_list_item.dart';
import 'package:minhund/presentation/widgets/reorderable_list.dart';
import 'package:minhund/provider/journal_event_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

import 'journal_event_dialog.dart';

class JournalEventPageController extends MasterPageController {
  final JournalCategoryItem categoryItem;

  List<JournalEventItem> upcomingEvents = [];
  List<JournalEventItem> completedEvents = [];

  final void Function(bool refreshParent) onUpdate;

  final void Function(String deletedEventId) onEventAction;

  final Dog dog;

  final User user;

  JournalEventPageController(
      {this.dog,
      this.user,
      this.categoryItem,
      this.onUpdate,
      this.onEventAction});

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
                  singleCategoryItem: categoryItem,
                  childOnSaved: () => refresh(),
                  childOnDelete: () {
                    dog.journalItems
                        .removeWhere((item) => item.id == categoryItem.id);
                    onUpdate(true);
                    Navigator.of(context)..pop()..pop();
                  },
                  pageState: PageState.edit,
                  dogDocRefPath: dog.docRef.path,
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
                categoryItem: categoryItem,
                parentDocRef: dog.docRef,
                onDelete: (id) => onEventAction(id),
                pageState: PageState.create,
                onSave: (item) {
                  onSaveItem(item);
                },
              ),
            )),
      );

  @override
  String get title => categoryItem.title;

  @override
  void initState() {
    super.initState();
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

  onSaveItem(JournalEventItem item) {
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
      if (item.completed)
        compare = completedEvents;
      else
        compare = upcomingEvents;
      if (compare.isNotEmpty) if (compare[0] != item &&
          (compare[0].timeStamp != null && item.timeStamp != null)) if (item
              .timeStamp
              .isBefore(compare[0].timeStamp) &&
          compare[0].sortIndex != null) {
        item.sortIndex = 0;

        reOrder(compare.indexOf(item), item.sortIndex, compare);
      }
    }
    onEventAction(null);
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

      // eventItemList.forEach((item) {
      //   if (item.sortIndex != null) {
      //     int insertIndex = item.sortIndex;

      //     JournalEventItem reItem = item;
      //     eventItemList.eventItemList.remove(item);
      //     if (insertIndex <= eventItemList.length)
      //       eventItemList.insert(item.sortIndex, reItem);
      //   }
      // });
    }
  }

  void reOrder(int oldIndex, int newIndex, List<JournalEventItem> list) {
    JournalEventItem cItem = list.removeAt(oldIndex);

    JournalEventItem oldItem =
        list.firstWhere((i) => i.sortIndex == newIndex, orElse: () => null);

    cItem.sortIndex = newIndex;

    JournalEventProvider().update(model: cItem);

    list.insert(newIndex, cItem);

    if (oldItem != null) {
      oldItem.sortIndex = list.indexOf(oldItem);

      JournalEventProvider().update(model: oldItem);
    }
  }
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
                child: TabBar(
                  indicatorColor: ServiceProvider
                      .instance.instanceStyleService.appStyle.skyBlue,
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.only(
                    left: padding * 2,
                    right: padding * 2,
                    bottom: padding,
                  ),
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.timer,
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.imperial,
                        size: ServiceProvider.instance.instanceStyleService
                            .appStyle.iconSizeStandard,
                      ),
                      child: Text(
                        "Kommende",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.descTitle,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.check,
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.green,
                        size: ServiceProvider.instance.instanceStyleService
                            .appStyle.iconSizeStandard,
                      ),
                      child: Text(
                        "Fullførte",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.descTitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                key: Key(Random().nextInt(999999999).toString()),
                children: <Widget>[
                  ReorderableList(
                    onReorder: (oldIndex, newIndex) => controller.reOrder(
                        oldIndex, newIndex, controller.upcomingEvents),
                    widgetList: controller.upcomingEvents
                        .map(
                          (item) => JournalEventListItem(
                            key: Key(item.id ??
                                Random().nextInt(99999999).toString()),
                            controller: JournalEventListItemController(
                              user: controller.user,
                              categoryItem: controller.categoryItem,
                              dog: controller.dog,
                              onDeleteEvent: (id) =>
                                  controller.onEventAction(id),
                              onChanged: (item) {
                                controller.onSaveItem(item);
                              },
                              eventItem: item,
                            ),
                          ),
                        )
                        .toList(),
                  ),
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
                              dog: controller.dog,
                              onChanged: (item) {
                                controller.onSaveItem(item);
                              },
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
