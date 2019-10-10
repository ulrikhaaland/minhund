import 'package:flutter/material.dart';
import 'package:flutter/src/material/floating_action_button.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_list_item.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

import 'journal_event_dialog.dart';

class JournalEventPageController extends MasterPageController {
  final JournalCategoryItem categoryItem;

  List<JournalEventItem> upcomingEvents = [];
  List<JournalEventItem> completedEvents = [];

  final VoidCallback onUpdate;

  final Dog dog;

  JournalEventPageController({this.dog, this.categoryItem, this.onUpdate});

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;

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
                journalItems: dog.journalItems,
                parentDocRef: dog.docRef,
                pageState: PageState.create,
                onSave: (item) {
                  if (item != null) {
                    categoryItem.journalEventItems.add(item);
                    upcomingEvents.add(item);
                    sortListByDate(eventItemList: upcomingEvents);
                  }
                  setState(() {});
                },
              ),
            )),
      );

  @override
  String get title => categoryItem.title;

  @override
  void initState() {
    if (categoryItem.journalEventItems.isNotEmpty) {
      upcomingEvents = categoryItem.journalEventItems
          .where((item) => item.completed != true)
          .toList();
      completedEvents = categoryItem.journalEventItems
          .where((item) => item.completed == true)
          .toList();
    }

    super.initState();
  }

  void sortListByDate({@required List<JournalEventItem> eventItemList}) {
    eventItemList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
  }

  ListView listBuilder({@required List<JournalEventItem> list}) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return JournalEventListItem(
          controller: JournalEventListItemController(
            dog: dog,
            onChanged: (item) {
              if (item != null) {
                if (item.completed) {
                  completedEvents.add(item);
                  upcomingEvents.remove(item);
                } else {
                  upcomingEvents.add(item);
                  completedEvents.remove(item);
                }
              }
              sortListByDate(eventItemList: completedEvents);
              sortListByDate(eventItemList: upcomingEvents);

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

    return DefaultTabController(
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
                indicatorWeight: 5,
                indicatorPadding: EdgeInsets.all(
                  getDefaultPadding(context),
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
    );
  }
}
