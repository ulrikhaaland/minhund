import 'dart:io';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/helper/image_picker.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/info/dog/dog_info.dart';
import 'package:minhund/presentation/info/user/user_info.dart';
import 'package:minhund/provider/dog_provider.dart';
import 'package:minhund/provider/user_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class IntroInfoOwnerController extends MasterPageController {
  final User user;

  bool editingOwner = true;

  String pageTitle = "Eier";

  final VoidCallback onDone;

  File imageFile;

  String infoInfo = "Først trenger vi litt informasjon om deg";

  IntroInfoOwnerController({this.user, this.onDone});
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
  Widget get actionTwo => null;

  Future<void> saveInfo(Dog dog) async {
    if (user.dogs == null) {
      user.dogs = [];
    }

    if (!user.dogs.contains(dog)) {
      user.dogs.add(dog);
    }

    dog.journalItems = <JournalCategoryItem>[
      JournalCategoryItem(
        title: "Veterinær",
        sortIndex: 0,
      ),
      JournalCategoryItem(
        title: "Kurs",
        sortIndex: 1,
      ),
      JournalCategoryItem(
        title: "Annet",
        sortIndex: 2,
      ),
    ];

    await DogProvider().create(id: user.id, model: dog);

    onDone();

    if (imageFile != null) {
      dog.imgUrl = await FileProvider()
          .uploadFile(file: imageFile, path: "dogs/${dog.id}/${dog.id}");
      DogProvider().update(model: dog);
    }

    Navigator.pop(context);
  }
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
            height: getDefaultPadding(context) * 2,
          ),
          if (controller.editingOwner)
            UserInfo(
              controller: UserInfoController(
                  user: controller.user,
                  onDone: () => controller.setState(() {
                        controller.editingOwner = false;
                        controller.infoInfo =
                            "Fyll inn informasjon om din hund";
                        controller.pageTitle = "Hund";
                        if (controller.user.dogs == null)
                          controller.user.dogs = [];
                      })),
            ),
          if (!controller.editingOwner)
            DogInfo(
              controller: DogInfoController(
                  getImageFile: (file) => controller.imageFile = file,
                  user: controller.user,
                  dog: controller.user.dogs.isNotEmpty
                      ? controller
                          .user.dogs[controller.user.currentDogIndex ?? 0]
                      : Dog(),
                  onDone: (dog) async {
                    controller.saveInfo(dog);
                  }),
            )
        ],
      ),
    );
  }
}
