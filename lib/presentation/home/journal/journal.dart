import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/bottom_nav.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';

import '../../../bottom_navigation.dart';
import 'journal-event/journal_event_dialog.dart';
import 'journal-items/journal_items.dart';
import 'journal-items/journal_list_item.dart';

class JournalController extends BottomNavigationController {
  final User user;

  Dog dog;

  JournalController({this.user});

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
              ),
            )),
      );

  @override
  // TODO: implement title
  String get title => null;

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  void initState() {
    dog = user.dog;
    dog.profileImage.controller.imageSizePercentage = 5;

    super.initState();
  }
}

class Journal extends BottomNavigation {
  final JournalController controller;

  Journal({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    getTimeDifference(time: controller.dog.birthDate, daysMonthsYears: true);

    return SingleChildScrollView(
      child: Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 90),
        padding: EdgeInsets.all(getDefaultPadding(context) * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 7.5 * 1.8),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                controller.dog.name,
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${controller.dog.race}, ${getTimeDifference(time: controller.dog.birthDate, daysMonthsYears: true)}, ${controller.dog.weigth} kilo",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                        controller.user.dog.profileImage
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: getDefaultPadding(context) * 4,
            ),
            if (controller.dog.journalItems != null)
              Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 70),
                child: ListView.builder(
                  itemCount: controller.dog.journalItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (controller.dog.journalItems[index].title !=
                        "Legg til ny")
                      return Provider.value(
                        value: controller.dog,
                        child: JournalListItem(
                          controller: JournalListItemController(
                              item: controller.dog.journalItems[index]),
                        ),
                      );
                    else
                      return Container();
                  },
                ),
              ),
            // Column(
            //     children: controller.dog.journalItems.map((item) {
            //   if (item.title != "Legg til ny")
            //     return JournalListItem(
            //       controller: JournalListItemController(item: item),
            //     );
            //   else
            //     return Container();
            // }).toList())
          ],
        ),
      ),
    );
  }
}
