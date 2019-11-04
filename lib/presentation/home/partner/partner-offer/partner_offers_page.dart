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
import 'package:minhund/provider/partner/partner_offer_provider.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOffersPageController extends BottomNavigationController {
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

            return PartnerCRUDOffer(
              controller: PartnerCRUDOfferController(
                pageState: PageState.create,
                offer: partnerOffer,
                partnerId: partner.id,
                onCreate: (offer) {
                  partner.offers.add(offer);
                },
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

  void onDelete({PartnerOffer offer}) {
    partner.offers.removeWhere((off) => off.id == offer.id);
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
}

class PartnerOffersPage extends BottomNavigation {
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

    if (controller.loading) return Center(child: CPI(false));

    controller.sortListByDate(offerItemList: controller.inActiveOffers);
    controller.sortListByDate(offerItemList: controller.activeOffers);

    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            Card(
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
                tabs: <Widget>[
                  Container(
                    height: ServiceProvider.instance.instanceStyleService
                            .appStyle.iconSizeBig *
                        3,
                    child: Tab(
                      icon: Icon(
                        Icons.done,
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.green,
                        size: ServiceProvider
                            .instance.instanceStyleService.appStyle.iconSizeBig,
                      ),
                      child: Text(
                        "Aktive",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.descTitle,
                      ),
                    ),
                  ),
                  Container(
                    height: ServiceProvider.instance.instanceStyleService
                            .appStyle.iconSizeBig *
                        3,
                    child: Tab(
                      icon: Icon(
                        Icons.check_box_outline_blank,
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.imperial,
                        size: ServiceProvider
                            .instance.instanceStyleService.appStyle.iconSizeBig,
                      ),
                      child: Text(
                        "Inaktive",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.descTitle,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ],
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
                            key: Key(offer.id ??
                                Random().nextInt(99999999).toString()),
                            controller: PartnerOfferListItemController(
                              onDelete: (offer) =>
                                  controller.onDelete(offer: offer),
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
                            key: Key(offer.id ??
                                Random().nextInt(99999999).toString()),
                            controller: PartnerOfferListItemController(
                              onDelete: (offer) =>
                                  controller.onDelete(offer: offer),
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
