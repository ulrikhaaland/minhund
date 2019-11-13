import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/profile/dog_profile.dart';
import 'package:minhund/presentation/home/profile/user_profile.dart';
import 'package:minhund/presentation/widgets/expandable_card.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';
import '../../../bottom_navigation.dart';

class ProfilePageController extends MasterPageController {
  User user;

  static final ProfilePageController _instance =
      ProfilePageController._internal();

  factory ProfilePageController() {
    return _instance;
  }

  ProfilePageController._internal() {
    print("Profile Page built");
  }

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Profil";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;
}

class ProfilePage extends MasterPage {
  final ProfilePageController controller;

  ProfilePage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.user == null) controller.user = Provider.of<User>(context);

    double padding = getDefaultPadding(context);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpandableCard(
              title: "Generell Informasjon",
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.skyBlue,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Navn"),
                    Text(controller.user.name ?? "Ikke valgt")
                  ],
                )
              ],
            ),
            ExpandableCard(
              title:
                  controller.user.dogs.length > 1 ? "Mine Hunder" : "Min Hund",
              color:
                  ServiceProvider.instance.instanceStyleService.appStyle.green,
            ),
            ExpandableCard(
              title: "Innstillinger",
              color:
                  ServiceProvider.instance.instanceStyleService.appStyle.pink,
            ),
            ExpandableCard(
              title: "Medlemsskap",
              color:
                  ServiceProvider.instance.instanceStyleService.appStyle.leBleu,
            ),
          ],
        ),
      ),
    );
  }
}
