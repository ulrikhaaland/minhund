import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
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
  String get title => offer.title;

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
      width: ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (offer.imgUrl != null)
              CustomImage(
                controller: CustomImageController(
                    imgUrl: offer.imgUrl,
                    customImageType: CustomImageType.squared,
                    imageSizePercentage: 50),
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
                height: padding * 4,
              ),
              Text(
                offer.partnerReservation.amount.toString() +
                    " stk tilgjengelig",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.italic,
              ),
              SecondaryButton(
                text: "Reserver",
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.skyBlue,
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
            if (offer.partner != null) ...[
              Divider(
                thickness: 1,
              ),
              Container(
                height: padding * 4,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                // decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (offer.partner.imgUrl != null)
                      CustomImage(
                        controller: CustomImageController(
                          imgUrl: offer.partner.imgUrl,
                          customImageType: CustomImageType.circle,
                          imageSizePercentage: 6,
                        ),
                      ),
                    Container(
                      width: padding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (offer.partner.name != null)
                          Text(
                            offer.partner.name,
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.descTitle,
                          ),
                        if (offer.partner.websiteUrl != null)
                          InkWell(
                            onTap: () {
                                const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
                            },
                                                      child: Text(
                              offer.partner.websiteUrl,
                              style: ServiceProvider
                                  .instance.instanceStyleService.appStyle.body1
                                  .copyWith(
                                      color: ServiceProvider.instance
                                          .instanceStyleService.appStyle.leBleu,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (offer.partner.address != null)
                          Row(
                            children: <Widget>[
                              if (offer.partner.address.address != null)
                                Text(
                                  offer.partner.address.address + ",",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1Black,
                                ),
                              if (offer.partner.address.city != null)
                                Text(
                                  offer.partner.address.city,
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1Black,
                                ),
                            ],
                          ),
                        if (offer.partner.openingHours != null) ...[
                          if (offer.partner.openingHours.dayFrom != null &&
                              offer.partner.openingHours.dayTo != null)
                            Row(
                              children: <Widget>[
                                Text(
                                  "Hverdager: ",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.italic,
                                ),
                                Text(
                                  formatDate(
                                          time: true,
                                          date: offer
                                              .partner.openingHours.dayFrom) +
                                      "-" +
                                      formatDate(
                                          time: true,
                                          date:
                                              offer.partner.openingHours.dayTo),
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1Black,
                                ),
                              ],
                            ),
                          if (offer.partner.openingHours.weekendFrom != null &&
                              offer.partner.openingHours.weekendTo != null)
                            Row(
                              children: <Widget>[
                                Text(
                                  "Helger: ",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.italic,
                                ),
                                Text(
                                  formatDate(
                                          time: true,
                                          date: offer.partner.openingHours
                                              .weekendFrom) +
                                      "-" +
                                      formatDate(
                                          time: true,
                                          date: offer
                                              .partner.openingHours.weekendTo),
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1Black,
                                ),
                              ],
                            )
                        ],
                      ],
                    ),
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
