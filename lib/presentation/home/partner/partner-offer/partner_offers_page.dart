import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhund/bottom_navigation.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/customer/customer_reservation.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/partner/partner-reservation/partner_reservation.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_CRUD_offer.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_offer_list_item.dart';
import 'package:minhund/presentation/widgets/buttons/fab.dart';
import 'package:minhund/presentation/widgets/circular_progress_indicator.dart';
import 'package:minhund/presentation/widgets/reorderable_list.dart';
import 'package:minhund/provider/cloud_functions_provider.dart';
import 'package:minhund/provider/partner/partner_offer_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

abstract class OfferActionController {
  Future<void> onOfferUpdate({PartnerOffer offer});
  Future<void> onOfferDelete({PartnerOffer offer});
  Future<void> onOfferCreate({PartnerOffer offer});
}

class PartnerOffersPageController extends MasterPageController
    implements OfferActionController {
  final Partner partner;

  List<PartnerOffer> activeOffers = [];
  List<PartnerOffer> inActiveOffers = [];

  bool loading = true;

  PartnerOffersPageController({this.partner});
  @override
  Widget get bottomNav => null;

  @override
  String get title => "Tilbud";

  @override
  Widget get fab => Fab(
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            PartnerOffer partnerOffer = PartnerOffer();
            partnerOffer.partnerReservation = PartnerReservation();
            partnerOffer.partner = partner;
            partnerOffer.partnerId = partner.id;
            partnerOffer.type = OfferType.item;

            return PartnerCRUDOffer(
              controller: PartnerCRUDOfferController(
                actionController: this,
                pageState: PageState.create,
                offer: partnerOffer,
                partner: partner,
              ),
            );
          })));

  @override
  void initState() {
    getOffers();
    if (partner.offers == null) partner.offers = [];
    super.initState();
  }

  Future getOffers() {
    return PartnerOfferProvider().getCollection(id: partner.id).then((list) {
      partner.offers = list;
      list.forEach((offer) {
        if (offer.partnerReservation.customerReservations == null)
          offer.partnerReservation.customerReservations =
              <CustomerReservation>[];

        Firestore.instance
            .collection(offer.docRef.path + "/reservations")
            .getDocuments()
            .then((qSnap) {
          if (qSnap.documents.isNotEmpty)
            qSnap.documents.forEach((doc) {
              if (doc.exists) {
                CustomerReservation customerReservation =
                    CustomerReservation.fromJson(doc.data);

                customerReservation.docRef = doc.reference;

                offer.partnerReservation.customerReservations
                    .add(customerReservation);
              }
            });
        });
      });
      setState(() => loading = false);
    });
  }

  void sortListByDate({@required List<PartnerOffer> offerItemList}) {
    if (offerItemList.isNotEmpty) {
      offerItemList.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null)
          return a.createdAt.compareTo(b.createdAt);
        else
          return 0;
      });
      offerItemList.sort((a, b) {
        if (a.sortIndex != null && b.sortIndex != null) {
          return a.sortIndex.compareTo(b.sortIndex);
        } else
          return 0;
      });
    }
  }

  void reOrder(int oldIndex, int newIndex, List<PartnerOffer> list) {
    PartnerOffer cItem = list.removeAt(oldIndex);

    PartnerOffer oldItem =
        list.firstWhere((i) => i.sortIndex == newIndex, orElse: () => null);

    cItem.sortIndex = newIndex;

    PartnerOfferProvider().update(model: cItem);

    list.insert(newIndex, cItem);

    if (oldItem != null) {
      oldItem.sortIndex = list.indexOf(oldItem);

      PartnerOfferProvider().update(model: oldItem);
    }
  }

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwoList
  List<Widget> get actionTwoList => null;

  @override
  Future<void> onOfferCreate({PartnerOffer offer}) {
    partner.offers.add(offer);
    return Future.value("");
  }

  @override
  Future<void> onOfferDelete({PartnerOffer offer}) {
    partner.offers.removeWhere((off) => off.id == offer.id);

    CloudFunctionsProvider()
        .recursiveUniversalDelete(path: "partnerOffers/${offer.id}");

    return Future.value("");
  }

  @override
  Future<void> onOfferUpdate({PartnerOffer offer}) {
    partner.offers.remove(partner.offers.firstWhere((of) => of.id == offer.id,
        orElse: () => partner.offers.firstWhere(
            (of) => of.createdAt == offer.createdAt,
            orElse: () => null)));

    partner.offers.add(offer);

    refresh();
    partner.docRef
        .collection("offers")
        .document(offer.id)
        .updateData(offer.toJson());
    return PartnerOfferProvider().update(model: offer);
  }

  @override
  bool get enabledTopSafeArea => null;

  @override
  bool get hasBottomNav => true;

  @override
  // TODO: implement disableResize
  bool get disableResize => null;
}

class PartnerOffersPage extends MasterPage {
  final PartnerOffersPageController controller;

  PartnerOffersPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    if (controller.partner.offers.isNotEmpty) {
      controller.activeOffers = controller.partner.offers
          .where((offer) => offer.active == true)
          .toList();

      controller.inActiveOffers = controller.partner.offers
          .where((offer) => offer.active != true)
          .toList();
    } else {
      controller.activeOffers = [];
      controller.inActiveOffers = [];
    }

    if (controller.loading) return Center(child: CPI());

    controller.sortListByDate(offerItemList: controller.inActiveOffers);
    controller.sortListByDate(offerItemList: controller.activeOffers);

    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: DefaultTabController(
        length: 2,
        initialIndex: controller.activeOffers.isNotEmpty
            ? 0
            : controller.inActiveOffers.isEmpty ? 0 : 1,
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
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.done,
                                color: ServiceProvider.instance
                                    .instanceStyleService.appStyle.green,
                                size: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .iconSizeStandard),
                            Text(
                              "Aktive",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.descTitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: ServiceProvider.instance.instanceStyleService
                              .appStyle.iconSizeStandard *
                          2,
                      padding: EdgeInsets.only(top: padding),
                      child: Tab(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.check_box_outline_blank,
                                color: ServiceProvider.instance
                                    .instanceStyleService.appStyle.imperial,
                                size: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .iconSizeStandard),
                            Text(
                              "Inaktive",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.descTitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                key: Key(Random().nextInt(999999999).toString()),
                children: <Widget>[
                  ReorderableList(
                    onReorder: (oldIndex, newIndex) => controller.reOrder(
                        oldIndex, newIndex, controller.activeOffers),
                    widgetList: controller.activeOffers
                        .map(
                          (offer) => PartnerOfferListItem(
                            key: UniqueKey(),
                            controller: PartnerOfferListItemController(
                              partner: controller.partner,
                              actionController: controller,
                              offer: offer,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ReorderableList(
                    onReorder: (oldIndex, newIndex) => controller.reOrder(
                        oldIndex, newIndex, controller.inActiveOffers),
                    widgetList: controller.inActiveOffers
                        .map(
                          (offer) => PartnerOfferListItem(
                            key: UniqueKey(),
                            controller: PartnerOfferListItemController(
                              partner: controller.partner,
                              actionController: controller,
                              offer: offer,
                            ),
                          ),
                        )
                        .toList(),
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
