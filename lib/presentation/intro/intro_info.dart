import 'dart:io';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/info/dog_info.dart';
import 'package:minhund/presentation/info/user_info.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class IntroInfoOwnerController extends MasterPageController {
  final User user;

  bool editingOwner = true;

  String pageTitle = "Eier";

  final void Function(Dog dog, File imageFile) onDone;

  File imageFile;

  DogInfoController dogInfoController;

  String infoInfo = "Først trenger vi litt informasjon om deg...";

  IntroInfoOwnerController({this.user, this.onDone});

  @override
  void initState() {
    dogInfoController = DogInfoController(
        getImageFile: (file) => imageFile = file,
        user: user,
        createOrUpdateDog: CreateOrUpdateDog.create,
        dog:
            user.dogs.isNotEmpty ? user.dogs[user.currentDogIndex ?? 0] : Dog(),
        onDone: (dog) async {
          user.docRef?.updateData({
            "introDone": true,
          });
          onDone(dog, imageFile);
          Navigator.pop(context);
        });
    super.initState();
  }

  @override
  Widget get bottomNav => null;

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => pageTitle;

  @override
  Widget get actionOne => IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        iconSize: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      );

  @override
  List<Widget> get actionTwoList => editingOwner
      ? null
      : [
          SaveButton(
            controller: SaveButtonController(onPressed: () async {
              dogInfoController.save();
            }),
          )
        ];

  @override
  bool get enabledTopSafeArea => null;

  @override
  bool get hasBottomNav => false;
}

class IntroInfoOwner extends MasterPage {
  final IntroInfoOwnerController controller;

  IntroInfoOwner({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            controller.infoInfo,
            style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
            textAlign: TextAlign.start,
          ),
          Container(
            height: getDefaultPadding(context) * 6,
          ),
          if (controller.editingOwner)
            UserInfo(
              controller: UserInfoController(
                  user: controller.user,
                  onDone: () => controller.setState(() {
                        controller.editingOwner = false;
                        controller.infoInfo = "...og litt om din hund";
                        controller.pageTitle = "Min Hund";
                        if (controller.user.dogs == null)
                          controller.user.dogs = [];
                      })),
            ),
          if (!controller.editingOwner)
            DogInfo(
              controller: controller.dogInfoController,
            )
        ],
      ),
    );
  }
}
