import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/presentation/home/journal/journal-category/journal_add_category.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_list_item.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

import 'journal_event_dialog.dart';

class JournalEventPageController extends MasterPageController {
  final JournalCategoryItem categoryItem;

  List<JournalEventItem> upcomingEvents = [];
  List<JournalEventItem> completedEvents = [];

  final void Function(bool refreshParent) onUpdate;

  final Dog dog;

  JournalEventPageController({this.dog, this.categoryItem, this.onUpdate});

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => IconButton(
        onPressed: () => showCustomDialog(
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
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        iconSize: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      );

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
                categoryItem: categoryItem,
                parentDocRef: dog.docRef,
                pageState: PageState.create,
                onSave: (item) {
                  refresh();
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

  void sortListByDate({@required List<JournalEventItem> eventItemList}) {
    if (eventItemList.isNotEmpty)
      eventItemList.sort((a, b) {
        if (a.timeStamp != null && b.timeStamp != null)
          a.timeStamp.compareTo(b.timeStamp);
        else
          return 0;
      });
  }

  ListView listBuilder({@required List<JournalEventItem> list}) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return JournalEventListItem(
          key: Key(list[index].id ?? Random().nextInt(99999999).toString()),
          controller: JournalEventListItemController(
            categoryItem: categoryItem,
            dog: dog,
            onChanged: (item) {
              refresh();
            },
            eventItem: list[index],
          ),
        );
      },
    );
  }
}

class JournalEventPage extends MasterPage {
  final JournalEventPageController controller;

  JournalEventPage({this.controller});
  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.categoryItem.journalEventItems.isNotEmpty) {
      controller.upcomingEvents = controller.categoryItem.journalEventItems
          .where((item) => item.completed != true)
          .toList();
      controller.completedEvents = controller.categoryItem.journalEventItems
          .where((item) => item.completed == true)
          .toList();
    } else {
      controller.upcomingEvents = [];
      controller.completedEvents = [];
    }

    controller.sortListByDate(eventItemList: controller.completedEvents);
    controller.sortListByDate(eventItemList: controller.upcomingEvents);

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
                          .instance.instanceStyleService.appStyle.pink,
                      size: ServiceProvider
                          .instance.instanceStyleService.appStyle.iconSizeBig,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.check,
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.green,
                      size: ServiceProvider
                          .instance.instanceStyleService.appStyle.iconSizeBig,
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  controller.listBuilder(list: controller.upcomingEvents),
                  controller.listBuilder(list: controller.completedEvents),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
