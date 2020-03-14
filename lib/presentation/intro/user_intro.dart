import 'dart:io';

import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/intro/intro_info.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/provider/dog_provider.dart';
import 'package:minhund/provider/file_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:minhund/utilities/master_page.dart';

class UserIntroController extends MasterPageController {
  final VoidCallback onIntroFinished;

  final User user;

  UserIntroController({this.onIntroFinished, this.user});

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Velkommen";

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;

  Future<void> saveInfo({Dog dog, File imageFile}) async {
    if (user.dogs == null) {
      user.dogs = [];
    }

    dog.journalItems = <JournalCategoryItem>[
      JournalCategoryItem(
        title: "Veterinær",
        sortIndex: 0,
        colorIndex: 1,
      ),
      JournalCategoryItem(
        title: "Kurs",
        sortIndex: 1,
        colorIndex: 4,
      ),
      JournalCategoryItem(
        title: "Annet",
        sortIndex: 2,
        colorIndex: 2,
      ),
    ];

    user.dog = dog;

    if (!user.dogs.contains(dog)) {
      user.dogs.add(dog);
    }

    await DogProvider().create(id: user.id, model: dog);

    onIntroFinished();

    if (imageFile != null) {
      try {
        dog.imgUrl = await FileProvider()
            .uploadFile(file: imageFile, path: "dogs/${dog.id}/${dog.id}");
      } catch (e) {
        print(e.toString());
      }

      DogProvider().update(model: dog);
    }
  }

  @override
  bool get enabledTopSafeArea => null;

  @override
  bool get hasBottomNav => false;

  @override
  // TODO: implement disableResize
  bool get disableResize => null;
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
                      onDone: (dog, imageFile) =>
                          controller.saveInfo(dog: dog, imageFile: imageFile),
                    )),
                  ),
                ),
              ),
            ),
            SecondaryButton(
              onPressed: () {
                controller.saveInfo(
                    dog: Dog(
                      name: "Min Hund",
                      weigth: "12",
                      birthDate: DateTime(
                        2015,
                        5,
                        15,
                      ),
                      race: "Beagle",
                    ),
                    imageFile: null);
              },
              text: "Jeg gjør det senere",
            ),
          ],
        ),
      ),
    );
  }
}
