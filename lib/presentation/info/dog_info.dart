import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/dog_provider.dart';
import 'package:minhund/provider/file_provider.dart';
import 'package:minhund/service/service_provider.dart';

enum CreateOrUpdateDog { create, update }

class DogInfoController extends BaseController {
  final User user;

  final Dog dog;

  final CreateOrUpdateDog createOrUpdateDog;

  final Future Function(Dog dog) onDone;

  final _formKey = GlobalKey<FormState>();

  PrimaryButtonController primaryButtonController;

  final FocusScopeNode _node = FocusScopeNode();
  List<Widget> textFields;

  bool isLoading = false;

  final void Function(File file) getImageFile;

  final ScrollController scrollController = ScrollController();

  File imageFile;

  DateTimePickerController dateTimePickerController;

  DogInfoController(
      {this.onDone,
      this.user,
      this.dog,
      this.createOrUpdateDog,
      this.getImageFile});

  @override
  void initState() {
    dateTimePickerController = DateTimePickerController(
        validate: true,
        asListTile: true,
        onConfirmed: (date) => dog?.birthDate = date,
        initialDate: dog?.birthDate,
        title: "Fødselsdato",
        label: "Fødselsdato");
    if (dog.address == null) dog.address = Address();
    textFields = <Widget>[
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        validate: true,
        initValue: dog?.name,
        onSaved: (val) => dog?.name = val.trim(),
        onFieldSubmitted: () => textFieldNext(10),
        hintText: "Navn",
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        textInputType: TextInputType.text,
      ),
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        validate: true,
        initValue: dog?.race,
        onSaved: (val) => dog?.race = val.trim(),
        onFieldSubmitted: () => textFieldNext(20),
        hintText: "Rase",
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        textInputType: TextInputType.text,
      ),
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        validate: true,
        initValue: dog?.weigth,
        onSaved: (val) => dog?.weigth = val.trim(),
        onFieldSubmitted: () => textFieldNext(30),
        hintText: "Vekt(kg)",
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        textInputType: TextInputType.number,
        maxLength: 4,
      ),
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        validate: true,
        initValue: dog?.address?.address,
        onSaved: (val) => dog?.address?.address = val.trim(),
        hintText: "Adresse",
        onFieldSubmitted: () => textFieldNext(40),
        autocorrect: false,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
      ),
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        validate: true,
        initValue: dog?.address?.city,
        onSaved: (val) => dog?.address?.city = val.trim(),
        hintText: "By",
        onFieldSubmitted: () => textFieldNext(50),
        autocorrect: false,
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
      ),
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        validate: true,
        initValue: dog?.address?.county,
        onSaved: (val) => dog?.address?.county = val.trim(),
        hintText: "Fylke",
        onFieldSubmitted: () =>
            dateTimePickerController.openDatePicker(context),
        autocorrect: false,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
      ),
      DateTimePicker(
        controller: dateTimePickerController,
      ),
      PrimaryTextField(
        paddingBottom: getDefaultPadding(context) * 2,
        asListTile: true,
        initValue: dog?.chipNumber,
        onSaved: (val) => dog?.chipNumber = val.trim(),
        onFieldSubmitted: () => _node.unfocus(),
        hintText: "Chip nummer (valgfritt)",
        validate: false,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.none,
        textInputType: TextInputType.number,
      ),
    ];
    primaryButtonController = PrimaryButtonController(
      text: "Bekreft ",
      onPressed: () async {
        primaryButtonController
            .setState(() => primaryButtonController.isLoading = true);
        _formKey.currentState.save();
        if (validateTextFields(textFields: textFields)) {
          getImageFile(imageFile);
          await onDone(dog);
        }
        primaryButtonController
            .setState(() => primaryButtonController.isLoading = false);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void textFieldNext(double heigth) {
    // scrollScreen(
    //     controller: scrollController,
    //     height: ServiceProvider.instance.screenService
    //         .getHeightByPercentage(context, heigth));
    _node.nextFocus();
  }

  Future<void> save() async {
    _formKey.currentState.save();
    if (validateTextFields(textFields: textFields)) {
      if (createOrUpdateDog == CreateOrUpdateDog.update) {
        Navigator.pop(context);
        DogProvider().update(model: dog);
        if (imageFile != null) {
          dog.imageFile = imageFile;
          FileProvider()
              .uploadFile(file: imageFile, path: "dogs/${dog.id}/${dog.id}")
              .then((url) {
            dog.imgUrl = url;
            dog.docRef.updateData({
              "imgUrl": dog.imgUrl,
            });
          });
        }
      } else {
        getImageFile(imageFile);
        await onDone(dog);
      }
    }
  }
}

class DogInfo extends BaseView {
  final DogInfoController controller;

  DogInfo({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    Widget form = Form(
      key: controller._formKey,
      child: FocusScope(
        node: controller._node,
        child: Column(
          children: <Widget>[
            CustomImage(
              key: Key(controller.user.dog?.imgUrl ??
                  controller.user.dog?.imageFile?.path ??
                  "asd"),
              controller: CustomImageController(
                  edit: true,
                  imgUrl: controller.dog.imgUrl,
                  imageFile: controller.dog.imageFile,
                  imageSizePercentage: 20,
                  provideImageFile: (file) => controller.imageFile = file,
                  onDelete: () {
                    controller.dog.imageFile = null;
                    if (controller.dog.imgUrl != null) {
                      FileProvider().deleteFile(
                          path:
                              "dogs/${controller.dog.id}/${controller.dog.id}");
                      controller.dog.imgUrl = null;
                      controller.dog.docRef.updateData({
                        "imgUrl": null,
                      });
                    }
                  }),
            ),
            Container(
              height: getDefaultPadding(context),
            ),
            Column(
              children: controller.textFields,
            ),
            Container(
              height: getDefaultPadding(context) * 4,
            )
          ],
        ),
      ),
    );

    if (controller.createOrUpdateDog == CreateOrUpdateDog.create) return form;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: getDefaultPadding(context) * 2),
            child: SaveButton(
              controller: SaveButtonController(onPressed: controller.save),
            ),
          )
        ],
      ),
      body: Scrollbar(
              child: SingleChildScrollView(
          child: Container(
            color: ServiceProvider
                .instance.instanceStyleService.appStyle.backgroundColor,
            child: Column(
              children: <Widget>[
                form,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
