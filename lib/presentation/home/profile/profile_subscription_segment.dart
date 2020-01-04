import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/service/service_provider.dart';

class ProfileSubscriptionSegment extends StatefulWidget {
  final User user;
  ProfileSubscriptionSegment({Key key, this.user}) : super(key: key);

  @override
  _ProfileSubscriptionSegmentState createState() =>
      _ProfileSubscriptionSegmentState();
}

class _ProfileSubscriptionSegmentState
    extends State<ProfileSubscriptionSegment> {
  @override
  Widget build(BuildContext context) {
    double padding = getDefaultPadding(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Swiper(
            autoplay: true,
            autoplayDisableOnInteraction: true,
            itemCount: swiperData.length,
            itemBuilder: (context, index) {
              SwiperItem item = swiperData[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: Icon(
                          item.iconData,
                          size: ServiceProvider.instance.instanceStyleService
                              .appStyle.iconSizeStandard,
                          color: item.themeColor,
                        ),
                      ),
                      Text(
                        item.title,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                      ),
                    ],
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Container(
                    width: ServiceProvider.instance.screenService.getWidthByPercentage(context, 80),
                                      child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        // Flexible(
        //   child: PrimaryButton(
        //     controller: PrimaryButtonController(
        //       elevation: 2,
        //       color: Colors.white,
        //       width: ServiceProvider.instance.screenService
        //           .getWidthByPercentage(context, 60),
        //       text: widget.user.isSubscribed ? "Mitt abonnement" : "Abonner",
        //       textStyle: ServiceProvider
        //           .instance.instanceStyleService.appStyle.buttonText
        //           .copyWith(
        //               color: ServiceProvider
        //                   .instance.instanceStyleService.appStyle.textGrey),
        //       onPressed: () => null,
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class SwiperItem {
  final IconData iconData;
  final String title;
  final String description;
  final Color themeColor;

  SwiperItem({this.themeColor, this.iconData, this.title, this.description});
}

List<SwiperItem> swiperData = [
  SwiperItem(
      title: "Eksklusive tilbud",
      description: "Få rabatter hos din lokale dyrebutikk. Se, reserver og hent",
      iconData: Icons.store,
      themeColor:
          ServiceProvider.instance.instanceStyleService.appStyle.textGrey),
  SwiperItem(
      title: "Lås opp journalen",
      description: "Få full oversikt over din hund's hverdag",
      iconData: Icons.description,
      themeColor:
          ServiceProvider.instance.instanceStyleService.appStyle.textGrey),
    SwiperItem(
      title: "Spar penger",
      description: "Bruk vårt fordelsprogram og spar penger på ditt hundehold",
      iconData: Icons.store,
      themeColor:
          ServiceProvider.instance.instanceStyleService.appStyle.textGrey),

];
