import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/info/dog/dog_info.dart';
import 'package:minhund/presentation/info/user/user_info.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/masterpage.dart';

class IntroInfoOwnerController extends MasterPageController {
  final User user;

  bool editingOwner = true;

  String pageTitle = "Eier";

  String infoInfo = "Først trenger vi litt informasjon om deg";

  IntroInfoOwnerController({this.user});
  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => pageTitle;

  @override
  // TODO: implement actionOne
  Widget get actionOne => IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        iconSize: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      );

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;
}

class IntroInfoOwner extends MasterPage {
  final IntroInfoOwnerController controller;

  IntroInfoOwner({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    return Column(
      children: <Widget>[
        Text(
          controller.infoInfo,
          style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
          textAlign: TextAlign.start,
        ),
        Container(
          height: getDefaultPadding(context) * 4,
        ),
        if (controller.editingOwner)
          UserInfo(
            controller: UserInfoController(
                user: controller.user,
                onDone: () => controller.setState(() {
                      controller.editingOwner = false;
                      controller.infoInfo = "Fyll inn informasjon om din hund";
                      controller.pageTitle = "Hund";
                    })),
          ),
        if (!controller.editingOwner)
          DogInfo(
            controller: DogInfoController(user: controller.user),
          )
      ],
    );
    // return Column(
    //   children: <Widget>[
    //     Text(
    //       "Først trenger vi litt informasjon om deg",
    //       style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
    //       textAlign: TextAlign.start,
    //     ),
    //     Container(
    //       height: getDefaultPadding(context) * 4,
    //     ),
    //     PrimaryTextField(
    //       hintText: "Ditt Navn",
    //       onSaved: (val) => val = controller.user.name,
    //     )
    //   ],
    // );
  }
}
