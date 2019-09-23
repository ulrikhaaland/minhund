import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/app_bar.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

enum ContentType { expertInfo, intro, choices }

class UserIntroController extends BaseController {
  final VoidCallback onIntroFinished;

  final User user;

  String skole;
  String linje;
  String bio;

  ContentType _contentType = ContentType.intro;

  UserIntroController({this.user, this.onIntroFinished});
}

class UserIntro extends BaseView {
  final UserIntroController controller;

  UserIntro({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      introPage(
          null,
          "Bruk søkefeltet for å finne frem til det du leter etter, klikk deretter på ønsket ekspert.",
          1),
      introPage(
          null,
          "Vurder om eksperten passer for deg, hvis så trykk på pluss knappen",
          2),
      introPage(null,
          "Forklar hva din henvendelse gjelder og send til eksperten.", 3),
      // userInfo(),
    ];
    Widget content;

    switch (controller._contentType) {
      case ContentType.expertInfo:
        content = Container();
        break;
      case ContentType.intro:
        content = Swiper(
          loop: false,
          autoplayDelay: 4500,
          itemBuilder: (BuildContext context, int index) {
            return list[index];
          },
          itemCount: list.length,
        );
        break;
      case ContentType.choices:
        content = Column(
          children: <Widget>[
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 15),
            ),
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 7.5),
              child: Text(
                "Du har 2 valgmuligheter",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: GestureDetector(
                onTap: () => _groupDecision(1),
                child: Card(
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.backgroundColor,
                  child: Container(
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 85),
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 15),
                    child: Center(
                      child: Text(
                        "Gå videre som bruker",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1Light,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Text(
                "ELLER",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24, top: 24),
              child: GestureDetector(
                onTap: () => _groupDecision(2),
                child: Card(
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.imperial,
                  child: Container(
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 85),
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 15),
                    child: Center(
                      child: Text("Registrer deg som ekspert",
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.body1Light),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Du kan når som helst endre valget ditt",
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.body1Light,
            )
          ],
        );
        break;
    }

    return Scaffold(
        backgroundColor: controller._contentType == ContentType.intro ||
                controller._contentType == ContentType.choices
            ? ServiceProvider.instance.instanceStyleService.appStyle.green
            : Colors.white,
        body: content);
  }

  void _groupDecision(int decision) {
    switch (decision) {
      case 1:
        controller.onIntroFinished();
        break;
      case 2:
        controller._contentType = ContentType.expertInfo;
        controller.refresh();
        break;
      case 3:
        break;

      default:
    }
  }

  Widget introPage(String imageLink, String textDesc, int pos) {
    Color one = ServiceProvider.instance.instanceStyleService.appStyle.textGrey;
    Color two = ServiceProvider.instance.instanceStyleService.appStyle.textGrey;
    Color three =
        ServiceProvider.instance.instanceStyleService.appStyle.textGrey;

    switch (pos) {
      case 1:
        one = ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor;

        break;
      case 2:
        two = ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor;
        break;
      case 3:
        three = ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor;
    }
    return Column(
      children: <Widget>[
        HenvendAppBar(
          title: "Slik fungerer det",
          titleStyle:
              ServiceProvider.instance.instanceStyleService.appStyle.title,
        ),
        Container(
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 90),
          padding: EdgeInsets.only(bottom: getDefaultPadding(context) * 4),
          child: Text(
            textDesc,
            style: ServiceProvider
                .instance.instanceStyleService.appStyle.body1Light,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 50),
          child: Image.asset(
            imageLink,
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: getDefaultPadding(context) * 4),
            height: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: CircleAvatar(
                    radius: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2),
                    child: Text(
                      "1",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: one,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: CircleAvatar(
                    radius: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2),
                    child: Text(
                      "2",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: two,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: CircleAvatar(
                    radius: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2),
                    child: Text(
                      "3",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: three,
                  ),
                ),
              ],
            )),
        Container(
          height: ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 1),
        ),
        PrimaryButton(
          controller: PrimaryButtonController(
            bottomPadding: 0,
            text: "Jeg forstår",
            onPressed: () {
              controller._contentType = ContentType.choices;
              controller.refresh();
            },
          ),
        ),
      ],
    );
  }
}
