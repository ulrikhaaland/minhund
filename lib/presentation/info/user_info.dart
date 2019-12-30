import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:flutter/material.dart';
import 'package:minhund/provider/user_provider.dart';
import 'package:minhund/service/service_provider.dart';

class UserInfoController extends BaseController {
  final User user;

  final VoidCallback onDone;

  final PageState pageState;

  final _formKey = GlobalKey<FormState>();

  final FocusScopeNode _node = FocusScopeNode();

  UserInfoController({this.user, this.onDone, this.pageState = PageState.create});

  List<PrimaryTextField> textFields;

  @override
  void initState() {
    textFields = [
      PrimaryTextField(
        asListTile: true,
        validate: true,
        initValue: user.name,
        onSaved: (val) => user.name = val.trim(),
        onFieldSubmitted: () => _node.nextFocus(),
        hintText: "Fullt navn",
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
      ),
      PrimaryTextField(
        asListTile: true,
        validate: true,
        regExType: RegExType.email,
        textCapitalization: TextCapitalization.none,
        initValue: user.email,
        textInputType: TextInputType.emailAddress,
        onSaved: (val) => user.email = val.trim().toLowerCase(),
        hintText: "Email",
        onFieldSubmitted: () => _node.nextFocus(),
        autocorrect: false,
      ),
      PrimaryTextField(
        asListTile: true,
        validate: true,
        prefixText: "+47 ",
        regExType: RegExType.phone,
        initValue: user.phoneNumber,
        textCapitalization: TextCapitalization.sentences,
        onSaved: (val) => user.phoneNumber = val.trim(),
        onFieldSubmitted: () => _node.nextFocus(),
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.phone,
        hintText: "Telefonnummer",
        autocorrect: false,
      ),
    ];
    super.initState();
  }

  @override
  dispose() {
    _node.dispose();
    super.dispose();
  }

  void onSave() {
    _formKey.currentState.save();
    if (validateTextFields(textFields: textFields)) {
      if (user.docRef == null)
        user.docRef = Firestore.instance.document("users/${user.id}");
      UserProvider().update(model: user);
      if (pageState == PageState.create) {
        onDone();
      } else {
        Navigator.pop(context);
      }
    }
  }
}

class UserInfo extends BaseView {
  final UserInfoController controller;

  UserInfo({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    Widget info = Form(
      key: controller._formKey,
      child: FocusScope(
        node: controller._node,
        child: Column(
          children: <Widget>[
            Column(
              children: controller.textFields,
            ),
            if (controller.pageState == PageState.create)
              PrimaryButton(
                controller: PrimaryButtonController(
                    text: "Gå videre", onPressed: controller.onSave),
              ),
          ],
        ),
      ),
    );
    if (controller.pageState == PageState.create) return info;

    return Scaffold(
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      appBar: AppBar(
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: getDefaultPadding(context) * 2),
            child: SaveButton(
              controller: SaveButtonController(
                onPressed: controller.onSave,
              ),
            ),
          )
        ],
      ),
      body: Center(child: info),
    );
  }
}
