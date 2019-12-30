import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/journal/journal-category/journal_add_category.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_page.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/reorderable_list.dart';
import 'package:minhund/provider/cloud_functions_provider.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';
import 'journal-category/journal_category_list_item.dart';
import 'journal-event/journal_event_dialog.dart';

class JournalPageController extends MasterPageController
    implements CategoryActionController {
  static final JournalPageController _instance =
      JournalPageController._internal();

  factory JournalPageController() {
    return _instance;
  }

  JournalPageController._internal() {
    print("Journal Page built");
  }

  List<JournalEventItem> eventItems = [];

  JournalEventItem nextEvent;
  JournalEventItem latestEvent;

  User user;

  Dog dog;

  bool isLoading = true;

  int nextEventColorIndex = 0;
  int completedEventColorIndex = 0;

  Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
        Duration(minutes: 10), (_) => setLatestAndUpcomingEvent());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
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
              actionController: this,
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
    if (dog.docRef != null) {
      user.dogs.forEach((dog) async {
        dog.journalItems =
            await JournalProvider().getCollection(id: dog.docRef.path);
        setState(() {});
      });
    }
    isLoading = false;
  }

  setLatestAndUpcomingEvent() {
    nextEvent = null;
    latestEvent = null;

    List<JournalEventItem> upcomingList = [];
    List<JournalEventItem> latestList = [];

    upcomingList = eventItems.where((i) {
      if (i.timeStamp == null) return false;
      return i.timeStamp?.isAfter(DateTime.now());
    }).toList();
    latestList = eventItems.where((i) {
      if (i.timeStamp == null) return false;
      return i.timeStamp?.isBefore(DateTime.now());
    }).toList();

    upcomingList.sort((a, b) {
      a.timeStamp = a.timeStamp ?? DateTime(2069);
      b.timeStamp = b.timeStamp ?? DateTime(2420);

      return a.timeStamp.compareTo(b.timeStamp);
    });

    latestList.sort((a, b) {
      a.timeStamp = a.timeStamp ?? DateTime(2069);
      b.timeStamp = b.timeStamp ?? DateTime(2420);

      return a.timeStamp.compareTo(b.timeStamp);
    });

    if (upcomingList.isNotEmpty) nextEvent = upcomingList[0];
    if (latestList.isNotEmpty) latestEvent = latestList[0];

    setState(() {});
  }

  @override
  bool get enabledTopSafeArea => null;

  @override
  Future<void> onCategoryCreate({JournalCategoryItem category}) {
    dog.journalItems.add(category);

    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JournalEventPage(
                  controller: JournalEventPageController(
                    actionController: this,
                    categoryItem: category,
                  ),
                )));

    return JournalProvider().create(model: category, id: dog.docRef.path);
  }

  @override
  Future<void> onCategoryDelete({JournalCategoryItem category}) {
    dog.journalItems.removeWhere((item) => item.id == category.id);

    eventItems.removeWhere((i) => i.categoryId == category.id);

    setLatestAndUpcomingEvent();

    String pathFromDog = category.docRef.path.split("dogs")[1];

    return CloudFunctionsProvider().recursiveUserSpecificDelete(
        pathAfterTypeId: "dogs$pathFromDog", userType: UserType.user);
  }

  @override
  Future<void> onCategoryUpdate({JournalCategoryItem category}) {
    eventItems
        .where((i) => i.categoryId == category.id)
        .forEach((eventItem) => eventItem.colorIndex == category.colorIndex);

    setLatestAndUpcomingEvent();

    Navigator.pop(context);

    return JournalProvider().update(model: category);
  }

  @override
  bool get hasBottomNav => true;
}

class JournalPage extends MasterPage {
  final JournalPageController controller;

  JournalPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.user == null ||
        controller.user != Provider.of<User>(context)) {
      controller.isLoading = true;
      controller.user = Provider.of<User>(context);
    }

    controller.dog = controller.user.dog;

    if (controller.isLoading) controller.getJournalItems();

    getTimeDifference(time: controller.dog.birthDate, daysMonthsYears: true);

    return Container(
      padding: EdgeInsets.only(
          left: getDefaultPadding(context) * 2,
          right: getDefaultPadding(context) * 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header(),
          if (controller.nextEvent != null) _nextEvent(),
          if (controller.latestEvent != null) _previousCompletedEvent(),
          Container(
            height: getDefaultPadding(context) * 4,
          ),
          if (controller.dog.journalItems != null) _categoryItems()
        ],
      ),
    );
  }

  Widget _nextEvent() {
    return InkWell(
      onTap: () => showCustomDialog(
        context: context,
        child: JournalEventDialog(
          controller: JournalEventDialogController(
            user: controller.user,
            canEdit: false,
            eventItem: controller.nextEvent,
            pageState: PageState.read,
          ),
        ),
      ),
      child: Card(
        color: Colors.white,
        elevation:
            ServiceProvider.instance.instanceStyleService.appStyle.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ServiceProvider
              .instance.instanceStyleService.appStyle.borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(getDefaultPadding(context)),
          child: RichText(
            key: Key(controller.nextEvent.timeStamp.toString()),
            overflow: TextOverflow.clip,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Neste: ",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.italic),
              TextSpan(
                  text: controller.nextEvent.title,
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.body1
                      .copyWith(
                          color: ServiceProvider
                              .instance
                              .instanceStyleService
                              .appStyle
                              .palette[controller.nextEventColorIndex ?? 0])),
              if (controller.nextEvent.timeStamp != null)
                TextSpan(
                    text: " " +
                        formatDifference(
                            date2: DateTime.now(),
                            date1: controller.nextEvent.timeStamp,
                            futureString: true),
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.italic),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Card(
      color: Colors.white,
      elevation:
          ServiceProvider.instance.instanceStyleService.appStyle.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ServiceProvider
            .instance.instanceStyleService.appStyle.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(getDefaultPadding(context) * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
            CustomImage(
              key: Key(controller.user.dog.imgUrl ??
                  controller.user.dog.imageFile?.path ??
                  "asd"),
              controller: CustomImageController(
                  imageSizePercentage: 10,
                  imgUrl: controller.dog.imgUrl,
                  imageFile: controller.dog.imageFile,
                  edit: false),
            )
          ],
        ),
      ),
    );
  }

  Widget _previousCompletedEvent() {
    return InkWell(
      onTap: () => showCustomDialog(
        context: context,
        child: JournalEventDialog(
          controller: JournalEventDialogController(
            user: controller.user,
            canEdit: false,
            eventItem: controller.latestEvent,
            pageState: PageState.read,
          ),
        ),
      ),
      child: Card(
        color: Colors.white,
        elevation:
            ServiceProvider.instance.instanceStyleService.appStyle.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ServiceProvider
              .instance.instanceStyleService.appStyle.borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(getDefaultPadding(context)),
          child: RichText(
            key: Key(controller.latestEvent.timeStamp.toString()),
            overflow: TextOverflow.clip,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Siste: ",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.italic),
              TextSpan(
                  text: controller.latestEvent.title,
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.body1
                      .copyWith(
                          color: ServiceProvider.instance.instanceStyleService
                                  .appStyle.palette[
                              controller.latestEvent.colorIndex ?? 0])),
              if (controller.latestEvent.timeStamp != null)
                TextSpan(
                    text: " " +
                        formatDifference(
                            date2: DateTime.now(),
                            date1: controller.latestEvent.timeStamp,
                            futureString: false),
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.italic),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _categoryItems() {
    return Flexible(
      flex: 4,
      child: ReorderableList(
          onReorder: (oldIndex, newIndex) {
            JournalCategoryItem cItem =
                controller.dog.journalItems.removeAt(oldIndex);

            JournalCategoryItem oldItem = controller.dog.journalItems
                .firstWhere((i) => i.sortIndex == newIndex, orElse: () => null);

            cItem.sortIndex = newIndex;

            JournalProvider().update(model: cItem);

            controller.dog.journalItems.insert(newIndex, cItem);

            if (oldItem != null) {
              oldItem.sortIndex = controller.dog.journalItems.indexOf(oldItem);

              JournalProvider().update(model: oldItem);
            }
          },
          widgetList: controller.dog.journalItems.map((item) {
            return JournalCategoryListItem(
                key: Key(item.id),
                controller: JournalCategoryListItemController(
                    actionController: controller, categoryItem: item));
          }).toList()),
    );
  }
}
