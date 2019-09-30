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

import '../../../bottom_navigation.dart';
import 'journal-items/journal_items.dart';

class JournalController extends BottomNavigationController {
  final User user;

  JournalController({this.user});

  @override
  FloatingActionButton get fab => FloatingActionButton(
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => print("open dialog"),
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
    super.initState();
  }
}

class Journal extends BottomNavigation {
  final JournalController controller;

  Journal({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    Dog dog = controller.user.dog;
    dog.profileImage.controller.imageSizePercentage = 5;

    getTimeDifference(time: dog.birthDate, daysMonthsYears: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(getDefaultPadding(context) * 2),
            child: Card(
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
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
                            dog.name,
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.title,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${dog.race}, ${getTimeDifference(time: dog.birthDate, daysMonthsYears: true)}, ${dog.weigth} kilo",
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.body1,
                            overflow: TextOverflow.ellipsis,
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
        JournalItemsPage(
          controller: JournalItemsController(journalItems: dog.journalItems),
        ),
      ],
    );
  }
}
