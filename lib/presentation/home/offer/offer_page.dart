import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/provider/offer_provider.dart';
import 'package:minhund/service/service_provider.dart';
import '../../../bottom_navigation.dart';
import 'customer_offer_list_item.dart';

class OfferPageController extends BottomNavigationController {
  List<Offer> offers;

  bool isLoading = true;

  OfferPageController();

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Tilbud";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;

  @override
  void initState() {
    getOffers();
    super.initState();
  }

  Future<void> getOffers() async {
    offers = await OfferProvider().getCollection(id: "partnerOffers");
    offers.shuffle();
    setState(() => isLoading = false);
  }
}

class OfferPage extends BottomNavigation {
  final OfferPageController controller;

  OfferPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted || controller.isLoading) return Container();

    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: controller.offers.length,
      itemBuilder: (BuildContext context, int index) => CustomerOfferListItem(
        offer: controller.offers[index],
        index: index,
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(
        2,
      ),
    );

    // return GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //   ),
    //   itemCount: controller.offers.length,
    //   scrollDirection: Axis.vertical,
    //   itemBuilder: (context, index) {
    //     return CustomerOfferListItem(
    //       offer: controller.offers[index],
    //       index: index,
    //     );
    //   },
    // );
    // This creates two columns with two items in each column
    // return GridView.count(
    //   childAspectRatio: 0.5,
    //   crossAxisCount: 2,
    //   children: List<CustomerOfferListItem>.generate(controller.offers.length,
    //       (index) {
    //     return CustomerOfferListItem(
    //       offer: controller.offers[index],
    //       index: index,
    //     );
    //   }, growable: true),
    // );
  }
}
