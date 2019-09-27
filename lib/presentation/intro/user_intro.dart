import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/intro/intro_info_owner.dart';
import 'package:minhund/presentation/widgets/app_bar.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:minhund/utilities/masterpage.dart';

class UserIntroController extends MasterPageController {
  final VoidCallback onIntroFinished;

  final User user;

  UserIntroController({this.onIntroFinished, this.user});

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => "Velkommen";

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;
}

class UserIntro extends MasterPage {
  final UserIntroController controller;

  UserIntro({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    return Container(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 90),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Min Hund er en tjeneste med et mål om å gjøre hundeieres hverdag enklere og oversiktlig.",
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.body1,
              textAlign: TextAlign.start,
            ),
            Container(
              height: getDefaultPadding(context) * 4,
            ),
            Text(
              "For å få fullt utbytte av tjenesten bør du fylle inn grunnleggende informasjon om din hund.",
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.body1,
              textAlign: TextAlign.start,
            ),
            PrimaryButton(
              controller: PrimaryButtonController(
                text: "Fyll inn informasjon nå",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroInfoOwner(
                        controller: IntroInfoOwnerController(
                      user: controller.user,
                    )),
                  ),
                ),
              ),
            ),
            SecondaryButton(
              onPressed: () => controller.onIntroFinished(),
              text: "Jeg gjør det senere",
            ),
          ],
        ),
      ),
    );
  }
}
