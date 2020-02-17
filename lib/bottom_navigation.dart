import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/home/journal/journal_page.dart';
import 'package:minhund/presentation/home/map/map_page.dart';
import 'package:minhund/presentation/home/offer/offer_page.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_offers_page.dart';
import 'package:minhund/presentation/home/profile/profile.dart';
import 'package:minhund/presentation/widgets/bottom_nav.dart';
import 'package:minhund/presentation/widgets/circular_progress_indicator.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/provider/dog_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';

import 'model/dog.dart';
import 'model/partner/partner.dart';
import 'model/user.dart';
import 'presentation/home/partner/partner_page.dart';

class BottomNavigationController extends MasterPageController {
  static final BottomNavigationController _instance =
      BottomNavigationController._internal();

  factory BottomNavigationController() {
    return _instance;
  }

  BottomNavigationController._internal() {
    print("Bottom Navigation Page built");
  }
  Widget bottomNavigationBar;
  int bottomNavIndex = 0;

  User user;

  // User Pages
  JournalPage journal;
  MapPage mapLocation;
  OfferPage offerPage;
  ProfilePage profile;

  // Partner Pages
  PartnerPage partnerPage;
  PartnerOffersPage partnerOffersPage;

  List<Widget> pages;

  bool _isLoading = false;

  bool enabled = true;

  @override
  void initState() {
    super.initState();
  }

  init() async {
    bottomNavigationBar = BottomNav(
      isPartner: user is Partner,
      onTabChanged: (index) {
        setState(() {
          index == 1 || index == 3 ? enabled = false : enabled = true;
          bottomNavIndex = index;
        });
      },
    );
    if (user is Partner) {
      partnerPage = PartnerPage(
        controller:
            PartnerPageController(pageState: PageState.read, partner: user),
      );

      partnerOffersPage = PartnerOffersPage(
        controller: PartnerOffersPageController(
          partner: user,
        ),
      );

      pages = <Widget>[
        partnerPage,
        partnerOffersPage,
      ];
    } else if (user is User) {
      await getDogs();

      journal = JournalPage(
        controller: JournalPageController(),
      );

      mapLocation = MapPage(
        controller: MapPageController(),
      );

      profile = ProfilePage(
        controller: ProfilePageController(),
      );

      offerPage = OfferPage(
        controller: OfferPageController(),
      );

      pages = <Widget>[journal, mapLocation, offerPage, profile];
    } else {
      dispose();
    }
    Timer(
        Duration(milliseconds: 50),
        () => setState(() {
              _isLoading = false;
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;

  @override
  Widget get bottomNav => bottomNavigationBar;

  @override
  String get title => null;

  @override
  Widget get fab => null;

  Future<void> getDogs() async {
    List<Dog> dogs = await DogProvider().getCollection(id: user.id);
    if (dogs.isNotEmpty) {
      user.dogs = dogs;
      if (user.dog == null) user.dog = dogs[0];
    } else {
      user.dog = Dog(
        name: "Min Hund",
        weigth: "12",
        birthDate: DateTime(
          2015,
          5,
          15,
        ),
        race: "Beagle",
      );

      DogProvider().create(model: user.dog);

      user.dog.journalItems = [];

      user.dogs = [
        user.dog,
      ];
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  bool get enabledTopSafeArea => enabled ?? true;

  @override
  bool get hasBottomNav => true;
}

class BottomNavigation extends MasterPage {
  final BottomNavigationController controller;

  final Key key;

  BottomNavigation({
    this.controller,
    this.key,
  }) : super(key: key);
  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.user == null ||
        controller.user != Provider.of<User>(context)) {
      controller.user = Provider.of<User>(context);
      controller.pages = null;
      controller.bottomNavIndex = 0;
      controller.init();
    }

    // if (!controller._isLoading) {
    //   if (controller.user.dog != null) if (controller.user.dog.profileImage ==
    //       null) {
    //     controller.user.dog.profileImage = CustomImage(
    //       controller: CustomImageController(
    //         customImageType: CustomImageType.circle,
    //         imgUrl: controller.user.dog.imgUrl,
    //       ),
    //     );
    //   } else {
    //     // controller.user.dog.profileImage.controller.edit = false;
    //   }
    // }

    if (controller.pages == null) return Container();

    return IndexedStack(
      index: controller.bottomNavIndex,
      children: controller._isLoading
          ? [Center(child: CPI())]
          : controller.pages,
    );
  }
}
