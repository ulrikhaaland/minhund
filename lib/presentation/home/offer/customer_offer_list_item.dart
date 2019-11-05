import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:provider/provider.dart';

import 'customer_offer_page.dart';

class CustomerOfferListItem extends StatefulWidget {
  Offer offer;

  final int index;

  CustomerOfferPageController customerOfferPageController;

  CustomerOfferListItem({Key key, this.offer, this.index}) : super(key: key);
  @override
  _CustomerOfferListItemState createState() => _CustomerOfferListItemState();
}

class _CustomerOfferListItemState extends State<CustomerOfferListItem> {
  @override
  void initState() {
    widget.offer.docRef.snapshots().listen((doc) {
      setState(() {
        widget.offer = Offer.fromJson(doc.data);

        if (widget.customerOfferPageController != null)
          widget.customerOfferPageController.refresh();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    Offer offer = widget.offer;

    return GestureDetector(
      onTap: () {
        User user = Provider.of<User>(context);
        if (widget.customerOfferPageController == null)
          widget.customerOfferPageController = CustomerOfferPageController(
            offer: widget.offer,
            user: user,
          );

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerOfferPage(
                  controller: widget.customerOfferPageController),
            ));
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: widget.index.isEven ? padding : padding,
            right: widget.index.isOdd ? padding : 0,
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
                        alignment: Alignment.center,
                        child: CustomImage(
                          controller: CustomImageController(
                              imgUrl: offer.imgUrl,
                              imageSizePercentage: 25,
                              customImageType: CustomImageType.squared),
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
