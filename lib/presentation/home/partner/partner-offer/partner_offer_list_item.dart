import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_CRUD_offer.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_offers_page.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOfferListItemController extends BaseController {
  final PartnerOffer offer;

  final PartnerOffersPageController actionController;

  final Partner partner;

  PartnerOfferListItemController({this.partner, 
    this.actionController,
    this.offer,
  });
}

class PartnerOfferListItem extends BaseView {
  final PartnerOfferListItemController controller;

  final Key key;

  PartnerOfferListItem({this.controller, this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return LayoutBuilder(
      builder: (context, constriants) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartnerCRUDOffer(
                controller: PartnerCRUDOfferController(
                  partner: controller.partner,
                  offer: controller.offer,
                  pageState: PageState.read,
                  actionController: controller.actionController,
                ),
              ),
            ),
          ),
          child: Container(
            width: constriants.maxWidth,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ServiceProvider
                    .instance.instanceStyleService.appStyle.borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              formatDate(
                                    date: controller.offer.createdAt,
                                  ) ??
                                  "Ingen dato satt",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.timestamp,
                            ),
                            Text(
                              "-",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.timestamp,
                            ),
                            Text(
                              formatDate(
                                    date: controller.offer.endOfOffer,
                                  ) ??
                                  "Ingen dato satt",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.timestamp,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Status: ",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.label),
                            Text(
                              controller.offer.inMarket == false
                                  ? "Avvist"
                                  : controller.offer.active ?? false
                                      ? "I markedet"
                                      : "Inaktivt",
                              style: ServiceProvider
                                  .instance.instanceStyleService.appStyle.body1,
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: padding * 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                controller.offer.title,
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.descTitle,
                                overflow: TextOverflow.clip,
                              ),
                              Container(
                                height: padding * 2,
                              ),
                              if (controller.offer.price != null)
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "NOK: ",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.label,
                                    ),
                                    Text(
                                      controller.offer.price.toString(),
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.body1,
                                    ),
                                  ],
                                ),
                              Container(
                                height: padding * 2,
                              ),
                              if (controller.offer.desc != null)
                                Text(
                                  controller.offer.desc,
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1,
                                ),
                            ],
                          ),
                        ),
                        if (controller.offer.imgUrl != null ||
                            controller.offer.imageFile != null)
                          Container(
                            height: ServiceProvider.instance.screenService
                                .getHeightByPercentage(context, 20),
                            child: CustomImage(
                              controller: CustomImageController(
                                  imgUrl: controller.offer.imgUrl,
                                  imageFile: controller.offer.imageFile,
                                  customImageType: CustomImageType.squared),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
