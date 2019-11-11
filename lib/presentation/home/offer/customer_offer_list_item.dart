import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:provider/provider.dart';

import 'customer_offer_page.dart';

class CustomerOfferListItemController extends BaseController {
  Offer offer;

  final int index;

  CustomerOfferListItemController({this.index, this.offer});

  @override
  void initState() {
    offer.docRef.snapshots().listen((doc) {
      offer = Offer.fromJson(doc.data);
      offer.docRef = doc.reference;

      refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CustomerOfferListItem extends BaseView {
  final CustomerOfferListItemController controller;

  CustomerOfferListItem({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    Offer offer = controller.offer;

    return GestureDetector(
      onTap: () {
        User user = Provider.of<User>(context);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerOfferPage(
                controller: CustomerOfferPageController(
                  offer: offer,
                  user: user,
                ),
              ),
            ));
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: controller.index.isEven ? padding : padding,
            right: controller.index.isOdd ? padding : 0,
            top: padding,
            bottom: padding),
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(20, 30))),
          elevation: 1,
          child: AnimatedContainer(
            alignment: Alignment.center,
            duration: Duration(milliseconds: 300),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                width: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (offer.imgUrl != null)
                      Container(
                        child: Hero(
                          tag: "img${offer.id}",
                          child: CustomImage(
                            controller: CustomImageController(
                                imgUrl: offer.imgUrl,
                                imageSizePercentage: 25,
                                customImageType: CustomImageType.squared),
                          ),
                        ),
                      ),
                    Container(
                      height: padding,
                    ),
                    Text(
                      offer.title ?? "",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.descTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      height: padding,
                    ),
                    Text(
                      offer.price.toString() + " kr.",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1Black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (offer.partner.name != null)
                      Text(
                        offer.partner.name,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1Black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (offer.partner.address.city != null)
                      Text(
                        offer.partner.address.city,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.coloredText,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
