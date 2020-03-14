import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/profile/user_profile.dart';
import 'package:minhund/presentation/info/user_info.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSettingsController extends MasterPageController {
  final User user;

  final VoidCallback onSignOut;

  ProfileSettingsController({this.onSignOut, this.user});
  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;

  @override
  Widget get bottomNav => null;

  @override
  bool get enabledTopSafeArea => null;

  @override
  Widget get fab => null;

  @override
  String get title => "Innstillinger";

  @override
  // TODO: implement hasBottomNav
  bool get hasBottomNav => false;

  @override
  // TODO: implement disableResize
  bool get disableResize => null;
}

class ProfileSettings extends MasterPage {
  final ProfileSettingsController controller;

  ProfileSettings({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfo(
                        controller: UserInfoController(
                      pageState: PageState.edit,
                      user: controller.user,
                    )),
                  )),
              title: Text(
                "Personlig informasjon",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.descTitle,
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(),
            )
          ],
        ),
        Column(
          children: <Widget>[
            ListTile(
              onTap: () => launchUrl(url: "https://mihu.no/terms"),
              title: Text(
                "Brukervilkår",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.descTitle,
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(),
            )
          ],
        ),
        Column(
          children: <Widget>[
            ListTile(
              onTap: () => launchUrl(url: "https://mihu.no/privacy"),
              title: Text(
                "Personvernpolicy",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.descTitle,
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(),
            )
          ],
        ),
        Column(
          children: <Widget>[
            ListTile(
              onTap: controller.onSignOut,
              title: Text(
                "Logg ut",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.descTitle,
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(),
            )
          ],
        ),
        Column(
          children: <Widget>[
            CheckboxListTile(
                title: Text(
                  "Tillat push-meldinger",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.descTitle,
                ),
                value: controller.user.allowsNotifications,
                onChanged: (val) {
                  controller.user.docRef?.updateData({
                    "allowsNotifications": val,
                  });
                  controller.setState(
                      () => controller.user.allowsNotifications = val);
                },
                activeColor: ServiceProvider
                    .instance.instanceStyleService.appStyle.green),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(),
            )
          ],
        ),
      ],
    );
  }
}
