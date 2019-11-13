import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/provider/offer_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
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
    super.initState();
  }

  Future<void> getOffers() async {
    offers = await OfferProvider().getCollection(id: "partnerOffers");
    offers.shuffle();
    setState(() => isLoading = false);
  }

  @override
  // TODO: implement actionTwoList
  List<Widget> get actionTwoList => null;
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
