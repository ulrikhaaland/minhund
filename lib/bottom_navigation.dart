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
  Widget bottomNavigationBar;
  int bottomNavIndex = 0;

  final User user;

  BottomNavigationController({this.user});

  // User Pages
  JournalPage journal;
  MapPage mapLocation;
  OfferPage offerPage;
  ProfilePage profile;

  // Partner Pages
  PartnerPage partnerPage;
  PartnerOffersPage partnerOffersPage;

  List<BottomNavigation> pages;

  bool _isLoading = true;

  @override
  void initState() {
    bottomNavigationBar = BottomNav(
      isUser: user is User,
      onTabChanged: (index) {
        bottomNavIndex = index;
        refresh();
      },
    );

    if (user is User) {
      getDogs();

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

      pages = <BottomNavigation>[journal, mapLocation, offerPage, profile];
    } else if (user is Partner) {
      partnerPage = PartnerPage(
        controller:
            PartnerPageController(pageState: PageState.read, partner: user),
      );

      partnerOffersPage = PartnerOffersPage(
        controller: PartnerOffersPageController(
          partner: user,
        ),
      );

      pages = <BottomNavigation>[
        partnerPage,
        partnerOffersPage,
      ];
      _isLoading = false;
    } else {
      dispose();
    }

    super.initState();
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
      user.dog = dogs[0];
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

      user.dogs = [
        user.dog,
      ];
    }
    setState(() {
      _isLoading = false;
    });
  }
}

class BottomNavigation extends MasterPage {
  final BottomNavigationController controller;

  BottomNavigation({
    this.controller,
  });
  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (!controller._isLoading) {
      if (controller.user.dog != null) if (controller.user.dog.profileImage ==
          null) {
        controller.user.dog.profileImage = CustomImage(
          controller: CustomImageController(
            customImageType: CustomImageType.circle,
            imgUrl: controller.user.dog.imgUrl,
          ),
        );
      } else {
        // controller.user.dog.profileImage.controller.edit = false;
      }
    }

    return MultiProvider(
      providers: [
        Provider<User>.value(value: controller.user),
      ],
      child: IndexedStack(
        index: controller.bottomNavIndex,
        children: controller._isLoading
            ? [Center(child: CPI(false))]
            : controller.pages,
      ),
    );
  }
}
