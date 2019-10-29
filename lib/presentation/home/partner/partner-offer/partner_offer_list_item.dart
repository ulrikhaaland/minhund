import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_CRUD_offer.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOfferListItemController extends BaseController {
  final PartnerOffer offer;

  final void Function(PartnerOffer offer) onDelete;

  PartnerOfferListItemController({this.offer, this.onDelete});
}

class PartnerOfferListItem extends BaseView {
  final PartnerOfferListItemController controller;

  final Key key;

  PartnerOfferListItem({this.controller, this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    PartnerOffer offer = controller.offer;

    return LayoutBuilder(
      builder: (context, constriants) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartnerCRUDOffer(
                controller: PartnerCRUDOfferController(
                  offer: offer,
                  pageState: PageState.read,
                  onDelete: (offer) => controller.onDelete(offer),
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
                                    date: offer.createdAt,
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
                                    date: offer.endOfOffer,
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
                              offer.inMarket != true
                                  ? "Venter på godkjenning"
                                  : offer.active ? "I markedet" : "Inaktivt",
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
                                offer.title,
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.descTitle,
                                overflow: TextOverflow.clip,
                              ),
                              Container(
                                height: padding * 2,
                              ),
                              if (offer.price != null)
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "NOK: ",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.label,
                                    ),
                                    Text(
                                      offer.price.toString(),
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.body1,
                                    ),
                                  ],
                                ),
                              Container(
                                height: padding * 2,
                              ),
                              if (offer.desc != null)
                                Text(
                                  offer.desc,
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1,
                                ),
                            ],
                          ),
                        ),
                        if (offer.imgUrl != null || offer.imageFile != null)
                          CustomImage(
                            controller: CustomImageController(
                                imgUrl: offer.imgUrl,
                                imageFile: offer.imageFile,
                                customImageType: CustomImageType.squared),
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
