import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/segments/partner_segment.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'customer_reserve_dialog.dart';

class CustomerOfferPageController extends MasterPageController {
  Offer offer;

  final User user;

  CustomerOfferPageController({this.offer, this.user});
  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwoList
  List<Widget> get actionTwoList => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement fab
  Widget get fab => null;

  @override
  // TODO: implement title
  String get title => offer.title ?? "";

  @override
  void initState() {
    super.initState();
  }
}

class CustomerOfferPage extends MasterPage {
  final CustomerOfferPageController controller;

  CustomerOfferPage({this.controller});
  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    Offer offer = controller.offer;

    return Container(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (offer.imgUrl != null)
              Hero(
                tag: "img${offer.id}",
                child: CustomImage(
                  controller: CustomImageController(
                    imgUrl: offer.imgUrl,
                    customImageType: CustomImageType.squared,
                    imageSizePercentage: 50,
                  ),
                ),
              ),
            Container(
              height: padding * 4,
            ),
            if (offer.price != null)
              Text(
                offer.price.toString() + " kr.",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.title,
                overflow: TextOverflow.ellipsis,
              ),
            if (offer.desc != null)
              Text(
                offer.desc,
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.body1Black,
              ),
            if (offer.partnerReservation.canReserve &&
                offer.partnerReservation.amount > 0) ...[
              Container(
                height: padding * 2,
              ),
              if (offer.partnerReservation.amount != null &&
                  offer.partnerReservation.amount > 0)
                Text(
                  offer.partnerReservation.amount.toString() +
                      " stk tilgjengelig",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.italic,
                ),
              SecondaryButton(
                text: "Reserver",
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.leBleu,
                onPressed: () => showCustomDialog(
                    context: context,
                    child: CustomerReserveDialog(
                      controller: CustomerReserveDialogController(
                        user: controller.user,
                        offer: offer,
                      ),
                    )),
              ),
            ],
            Divider(
              thickness: 1,
            ),
            Container(
              height: padding * 2,
            ),
            PartnerSegment(
              partner: offer.partner,
            )
          ],
        ),
      ),
    );
  }
}
