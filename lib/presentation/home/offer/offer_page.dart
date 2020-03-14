import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:minhund/helper/helper.dart';
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

  List<Offer> goods = [];
  List<Offer> services = [];
  List<Offer> web = [];

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
    goods = [];
    services = [];
    web = [];
    List<Offer> offers =
        await OfferProvider().getCollection(id: "partnerOffers");
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
    goods.addAll(offers.where((off) {
      if (off.type == null) {
        return true;
      } else if (off.type == OfferType.item) {
        return true;
      } else
        return false;
    }));

    services.addAll(offers.where((off) {
      if (off.type == OfferType.service) {
        return true;
      } else
        return false;
    }));

    web.addAll(offers.where((off) {
      if (off.type == OfferType.online) {
        return true;
      } else
        return false;
    }));
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
    double padding = getDefaultPadding(context);
    ScrollController scrollController = ScrollController();
    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  labelStyle: ServiceProvider
                      .instance.instanceStyleService.appStyle.descTitle,
                  indicatorColor: ServiceProvider
                      .instance.instanceStyleService.appStyle.skyBlue,
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.only(
                    left: padding * 4,
                    right: padding * 4,
                    bottom: padding,
                  ),
                  tabs: <Widget>[
                    Container(
                      height: ServiceProvider.instance.instanceStyleService
                              .appStyle.iconSizeStandard *
                          2,
                      padding: EdgeInsets.only(top: padding),
                      child: Tab(
                        text: "Varer",
                      ),
                    ),
                    Tab(
                      text: "Tjenester",
                    ),
                    Tab(
                      text: "På nett",
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                key: UniqueKey(),
                children: <Widget>[
                  StaggeredGridView.countBuilder(
                    controller: scrollController,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    itemCount: controller.goods.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CustomerOfferListItem(
                      controller: CustomerOfferListItemController(
                        offer: controller.goods[index],
                        index: index,
                      ),
                    ),
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(
                      2,
                    ),
                  ),
                  StaggeredGridView.countBuilder(
                    controller: scrollController,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    itemCount: controller.services.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CustomerOfferListItem(
                      controller: CustomerOfferListItemController(
                        offer: controller.services[index],
                        index: index,
                      ),
                    ),
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(
                      2,
                    ),
                  ),
                  StaggeredGridView.countBuilder(
                    controller: scrollController,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    itemCount: controller.web.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CustomerOfferListItem(
                      controller: CustomerOfferListItemController(
                        offer: controller.web[index],
                        index: index,
                      ),
                    ),
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(
                      2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
