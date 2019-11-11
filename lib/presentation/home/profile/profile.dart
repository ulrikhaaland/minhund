import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/profile/dog_profile.dart';
import 'package:minhund/presentation/home/profile/user_profile.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:provider/provider.dart';
import '../../../bottom_navigation.dart';

class ProfilePageController extends BottomNavigationController {
  User user;

  static final ProfilePageController _instance =
      ProfilePageController._internal();

  factory ProfilePageController() {
    return _instance;
  }

  ProfilePageController._internal() {
    print("Profile Page built");
  }

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Profil";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;
}

class ProfilePage extends BottomNavigation {
  final ProfilePageController controller;

  ProfilePage({this.controller});

  List<Tab> getTabs() {
    List<Tab> tabs = [];
    for (var i = 0; i < controller.user.dogs.length + 1; i++) {
      Dog dog;
      if (i < controller.user.dogs.length) dog = controller.user.dogs[i];

      tabs.add(Tab(
        child: Text(
          dog != null ? dog.name ?? "Hund $i" : controller.user.name ?? "Eier",
          style:
              ServiceProvider.instance.instanceStyleService.appStyle.descTitle,
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    if (controller.user == null) controller.user = Provider.of<User>(context);

    List<dynamic> dogsAndUser = [];

    controller.user.dogs.forEach((dog) => dogsAndUser.add(dog));

    dogsAndUser.add(controller.user);

    List<Tab> tabs = getTabs();

    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: DefaultTabController(
        length: dogsAndUser.length,
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
                    tabs: tabs),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: dogsAndUser.map((dog) {
                  if (dog is Dog)
                    return DogProfile(
                      controller: DogProfileController(
                        dog: dog,
                      ),
                    );
                  if (dog is User)
                    return UserProfile(
                        controller: UserProfileController(
                      user: dog,
                    ));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
