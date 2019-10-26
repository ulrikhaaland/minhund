import 'package:flutter/material.dart';
import 'package:minhund/bottom_navigation.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_CRUD_offer.dart';
import 'package:minhund/presentation/widgets/buttons/fab.dart';

class PartnerOffersPageController extends BottomNavigationController {
  final Partner partner;

  PartnerOffersPageController({this.partner});
  @override
  Widget get bottomNav => null;

  @override
  String get title => "Tilbud";

  @override
  Widget get fab => Fab(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartnerCRUDOffer(
              controller: PartnerCRUDOfferController(
                pageState: PageState.create,
                offer: PartnerOffer(),
                partnerId: partner.id,
                onCreate: (offer) {
                  partner.offers.add(offer);
                },
              ),
            ),
          )));

  @override
  void initState() {
    if (partner.offers == null) partner.offers = [];
    super.initState();
  }
}

class PartnerOffersPage extends BottomNavigation {
  final PartnerOffersPageController controller;

  PartnerOffersPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    return Container(
      child: Column(
        children:
            controller.partner.offers.map((offer) => Text("Offer")).toList(),
      ),
    );
  }
}
