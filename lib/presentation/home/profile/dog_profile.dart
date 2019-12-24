import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/expandable_card.dart';
import 'package:minhund/service/service_provider.dart';

class DogProfileController extends BaseController {
  final User user;

  DogProfileController({this.user});
}

class DogProfile extends BaseView {
  final DogProfileController controller;

  DogProfile({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: DefaultTabController(
        length: controller.user.dogs.length,
        initialIndex: controller.user.dogs.indexOf(controller.user.dog),
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
                  tabs: controller.user.dogs
                      .map((dog) => Tab(
                            child: Text(
                              dog.name ??
                                  "Hund " +
                                      controller.user.dogs
                                          .indexOf(dog)
                                          .toString(),
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.descTitle,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: controller.user.dogs
                    .map(
                      (dog) => Container(),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
