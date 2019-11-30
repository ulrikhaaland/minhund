import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerSegment extends StatelessWidget {
  final Partner partner;
  final bool withoutTitle;
  const PartnerSegment({Key key, this.partner, this.withoutTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (partner == null) return Container();

    double padding = getDefaultPadding(context);

    return Column(children: <Widget>[
      
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (partner.imgUrl != null)
              CustomImage(
                controller: CustomImageController(
                  imgUrl: partner.imgUrl,
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
                if (partner.name != null && withoutTitle != true)
                  Text(
                    partner.name,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.descTitle,
                  ),
                if (partner.address != null)
                  Row(
                    children: <Widget>[
                      if (partner.address.address != null)
                        Text(partner.address.address + ",",
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.body1Black),
                      if (partner.address.city != null)
                        Text(partner.address.city,
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.body1Black),
                    ],
                  ),
                if (partner.websiteUrl != null)
                  Text(partner.websiteUrl,
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1),
                if (partner.openingHours != null) ...[
                  if (partner.openingHours.dayFrom != null &&
                      partner.openingHours.dayTo != null)
                    Row(
                      children: <Widget>[
                        Text(
                          "Hverdager: ",
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.italic,
                        ),
                        Text(
                          formatDate(
                                  time: true,
                                  date: partner.openingHours.dayFrom) +
                              "-" +
                              formatDate(
                                  time: true, date: partner.openingHours.dayTo),
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.body1Black,
                        ),
                      ],
                    ),
                  if (partner.openingHours.weekendFrom != null &&
                      partner.openingHours.weekendTo != null)
                    Row(
                      children: <Widget>[
                        Text(
                          "Helger: ",
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.italic,
                        ),
                        Text(
                          formatDate(
                                  time: true,
                                  date: partner.openingHours.weekendFrom) +
                              "-" +
                              formatDate(
                                  time: true,
                                  date: partner.openingHours.weekendTo),
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.body1Black,
                        ),
                      ],
                    )
                ],
              ],
            ),
          ],
        ),
      ),
      Container(
        width: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 50),
        child: Row(
          children: <Widget>[
            if (partner.websiteUrl != null)
              SecondaryButton(
                text: "Nettsted",
                width: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 20),
                onPressed: () async {
                  String url = "https://" + partner.websiteUrl;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.skyBlue,
              ),
            Container(
              width: padding * 4,
            ),
            if (partner.long != null && partner.lat != null)
              SecondaryButton(
                text: "Veibeskrivelse",
                width: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 20),
                onPressed: () async {
                  if (partner.lat != null && partner.long != null) {
                    String googleUrl =
                        'https://www.google.com/maps/search/?api=1&query=${partner.lat},${partner.long}';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    } else {
                      throw 'Could not open the map.';
                    }
                  }
                },
              ),
          ],
        ),
      )
    ]);
  }
}
