import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/provider/offer_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';
import '../../../bottom_navigation.dart';
import 'customer_offer_list_item.dart';

class OfferPageController extends MasterPageController {
  static final OfferPageController _instance = OfferPageController._internal();

  factory OfferPageController() {
    return _instance;
  }

  OfferPageController._internal() {
    print("Offer Page built");
  }

  List<Offer> offers;

  bool isLoading = true;

  Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Tilbud";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  void initState() {
    getOffers();
    timer = Timer.periodic(Duration(hours: 1), (_) => getOffers());
    super.initState();
  }

  Future<void> getOffers() async {
    offers = await OfferProvider().getCollection(id: "partnerOffers");
    LocationData locationData = Provider.of<LocationData>(context);
    if (locationData != null)
      for (Offer offer in offers) {
        if (offer.partner.lat != null && offer.partner.long != null)
          offer.distanceInKm = Distance().distance(
              LatLng(locationData.latitude, locationData.longitude),
              LatLng(offer.partner.lat, offer.partner.long));
      }
    offers.sort((a, b) {
      if (a.distanceInKm != null && b.distanceInKm != null)
        return a.distanceInKm.compareTo(b.distanceInKm);
      else
        return 0;
    });
    offers.shuffle();
    setState(() => isLoading = false);
  }

  @override
  List<Widget> get actionTwoList => null;

  @override
  bool get enabledTopSafeArea => null;

  @override
  bool get hasBottomNav => true;
}

class OfferPage extends MasterPage {
  final OfferPageController controller;

  OfferPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted || controller.isLoading) return Container();

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
              children: controller.offers
                  .map((offer) => offer.imgUrl != null
                      ? CustomImage(
                          controller: CustomImageController(
                            imgUrl: offer.imgUrl,
                          ),
                        )
                      : Container())
                  .toList()),
        ),
        Container(
          color: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
        ),
        StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: controller.offers.length,
          itemBuilder: (BuildContext context, int index) =>
              CustomerOfferListItem(
            controller: CustomerOfferListItemController(
              offer: controller.offers[index],
              index: index,
            ),
          ),
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(
            2,
          ),
        ),
      ],
    );
  }
}
