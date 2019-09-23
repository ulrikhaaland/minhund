import 'dart:io';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/helper/image_picker.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';

class UserInfoController extends BaseController {
  final User user;
  final VoidCallback pushExpert;

  final _formKey = GlobalKey<FormState>();

  FocusNode _nameNode = FocusNode();
  FocusNode _bioNode = FocusNode();
  FocusNode _emailNode = FocusNode();

  FileProvider _fileProvider;

  File _expertImage;

  DateTimePickerController _dateTimePickerController;

  TextEditingController birthDateCtrlr = TextEditingController();

  UserInfoController({this.pushExpert, this.user});

  @override
  void initState() {
    _dateTimePickerController = DateTimePickerController(
      initialDate: user.birthDate,
      title: "Fødselsdato",
      onConfirmed: (val) {
        user.birthDate = val;
        fieldFocusChange(context, _emailNode, _bioNode);
      },
      label: "Fødselsdato",
    );
    super.initState();
  }

  bool onDone() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> uploadImage() async {
    return await FileProvider()
        .uploadFile(file: _expertImage, path: "users/${user.id}/pp");
  }

  void disposeAtWill() {
    // Clean up the focus node when the Form is disposed
    _bioNode.dispose();
    _nameNode.dispose();
    _emailNode.dispose();
    birthDateCtrlr.dispose();
    super.dispose();
  }
}

class UserInfo extends BaseView {
  final UserInfoController controller;

  UserInfo({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primaryButton = PrimaryButton(
      controller: PrimaryButtonController(
        width: 30,
        color: Colors.transparent,
        topPadding: 0,
        bottomPadding: 0,
        textStyle:
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black,
        text: "Fjern bilde",
        onPressed: () {
          controller._expertImage = null;
          controller.refresh();
        },
      ),
    );
    return Form(
      key: controller._formKey,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if (controller._fileProvider == null) {
                controller._fileProvider = FileProvider();
              }
              controller._fileProvider.getFile().then((file) {
                if (file != null) controller._expertImage = file;
                controller.refresh();
              });
            },
            child: CircleAvatar(
              radius: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 8.5),
              backgroundColor: ServiceProvider
                  .instance.instanceStyleService.appStyle.imperial,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (controller._expertImage == null) ...[
                    Icon(Icons.add_a_photo,
                        size: 40,
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.textGrey),
                    Container(
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 1),
                    ),
                    Text("Legg til et bilde",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1Light,
                        textAlign: TextAlign.center),
                  ] else ...[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 8.5),
                      backgroundImage: FileImage(controller._expertImage),
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (controller._expertImage != null) ...[
            // primaryButton,
          ] else ...[
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 7.5),
            )
          ],
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                top: getDefaultPadding(context) * 4,
                bottom: getDefaultPadding(context)),
            child: Text(
              "Personlig informasjon",
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.pageTitle,
              textAlign: TextAlign.start,
            ),
          ),
          PrimaryTextField(
            focusNode: controller._nameNode,
            initValue: controller.user.userName,
            onSaved: (val) => controller.user.userName = val.trim(),
            onFieldSubmitted: () => fieldFocusChange(
                context, controller._nameNode, controller._emailNode),
            labelText: "Fullt navn",
          ),
          PrimaryTextField(
            textCapitalization: TextCapitalization.none,
            focusNode: controller._emailNode,
            initValue: controller.user.email,
            onSaved: (val) => controller.user.email = val.trim(),
            onFieldSubmitted: () =>
                controller._dateTimePickerController.openDatePicker(),
            labelText: "Email",
          ),
          Row(
            children: <Widget>[
              // DateTimePicker(
              //   controller: controller._dateTimePickerController,
              // ),
            ],
          ),
          PrimaryTextField(
            focusNode: controller._bioNode,
            textCapitalization: TextCapitalization.sentences,
            initValue: controller.user.bio,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onSaved: (val) => controller.user.bio = val.trim(),
            hintText: "Fortell litt om deg selv",
            labelText: "Biografi",
            validate: false,
          ),
        ],
      ),
    );
  }
}
