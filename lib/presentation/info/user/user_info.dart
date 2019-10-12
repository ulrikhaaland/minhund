import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:flutter/material.dart';
import 'package:minhund/provider/user_provider.dart';

class UserInfoController extends BaseController {
  final User user;

  final VoidCallback onDone;

  final _formKey = GlobalKey<FormState>();

  final FocusScopeNode _node = FocusScopeNode();

  UserInfoController({this.user, this.onDone});

  List<PrimaryTextField> textFields;

  @override
  void initState() {
    textFields = [
      PrimaryTextField(
        initValue: user.name,
        onSaved: (val) => user.name = val.trim(),
        onFieldSubmitted: () => _node.nextFocus(),
        hintText: "Fullt navn",
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
      ),
      PrimaryTextField(
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
}

class UserInfo extends BaseView {
  final UserInfoController controller;

  UserInfo({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller._formKey,
      child: FocusScope(
        node: controller._node,
        child: Column(
          children: <Widget>[
            Column(
              children: controller.textFields,
            ),
            PrimaryButton(
              controller: PrimaryButtonController(
                text: "Gå videre",
                onPressed: () {
                  controller._formKey.currentState.save();
                  if (validateTextFields(textFields: controller.textFields)) {
                    UserProvider().update(model: controller.user);
                    controller.onDone();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
