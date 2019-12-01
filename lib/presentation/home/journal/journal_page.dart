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

class JournalPageController extends MasterPageController {
  static final JournalPageController _instance =
      JournalPageController._internal();

  factory JournalPageController() {
    return _instance;
  }

  JournalPageController._internal() {
    print("Journal Page built");
  }

  List<JournalEventItem> latestEvents = [];

  User user;

  Dog dog;

  bool isLoading = true;

  int eventColorIndex = 0;

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

  getLatestEvent(JournalEventItem item, int colorIndex, String deletedEventId) {
    if (deletedEventId != null)
      latestEvents.removeWhere((j) => j.id == deletedEventId);

    JournalEventItem oldItem =
        latestEvents.firstWhere((i) => i.id == item.id, orElse: () => null);
    if (oldItem != null) {
      latestEvents.remove(oldItem);
    }

    latestEvents.add(item);

    if (latestEvents.isNotEmpty)
      latestEvents.sort((a, b) {
        DateTime dateTimeA = a.timeStamp ?? DateTime(2050);
        DateTime dateTimeB = b.timeStamp ?? DateTime(2050);

        return dateTimeA.compareTo(dateTimeB);
      });
    if (item == latestEvents[0]) eventColorIndex = colorIndex;
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
          Card(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        controller.dog.name,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${controller.dog.race}, ${getTimeDifference(time: DateTime(2018, 3), daysMonthsYears: true)}, ${controller.dog.weigth} kilo",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                  controller.user.dog.profileImage
                ],
              ),
            ),
          ),
          if (controller.latestEvents.isNotEmpty)
            Card(
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
                  key: Key(controller.latestEvents[0].timeStamp.toString()),
                  overflow: TextOverflow.clip,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Neste: ",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.italic),
                    TextSpan(
                        text: controller.latestEvents[0].title,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1
                            .copyWith(
                                color: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .palette[controller.eventColorIndex])),
                    TextSpan(
                        text: " Om:" +
                            formatDifference(
                                date1: DateTime.now(),
                                date2: controller.latestEvents[0].timeStamp),
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.italic),
                  ]),
                ),
              ),
            ),
          Container(
            height: getDefaultPadding(context) * 4,
          ),
          if (controller.dog.journalItems != null)
            Expanded(
              child: Container(
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
                    widgetList: controller.dog.journalItems
                        .map(
                          (item) => JournalCategoryListItem(
                            key: Key(item.id),
                            controller: JournalCategoryListItemController(
                                returnLatest: (item, colorIndex, id) =>
                                    controller.getLatestEvent(
                                        item, colorIndex, id),
                                user: controller.user,
                                onUpdate: () => controller.setState(() {}),
                                dog: controller.dog,
                                item: item),
                          ),
                        )
                        .toList()),
              ),
            ),
        ],
      ),
    );
  }
}
