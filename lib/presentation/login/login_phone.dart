import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/root_page.dart';
import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

enum SignInStatus { enterNumber, enterCode }

class PhoneLoginController extends MasterPageController {
  final BaseAuth auth;

  final formKey = GlobalKey<FormState>();

  String _smsCode = "";
  String _verificationId;

  SignInStatus signInStatus = SignInStatus.enterNumber;

  String phoneNumber = "";

  PrimaryButtonController _saveButtonController;

  final RootPageController rootPageController;

  List<PrimaryTextField> textFields;

  PhoneLoginController({
    this.auth,
    this.rootPageController,
  });

  @override
  void initState() {
    _saveButtonController = PrimaryButtonController(
      text: "Send meg engangskode på SMS",
      onPressed: () async {
        formKey.currentState.save();
        try {
          if (signInStatus != SignInStatus.enterCode &&
              validateTextFields(singleTextField: textFields[0])) {
            _saveButtonController.isLoading = true;
            _saveButtonController.setState(() {});
            _saveButtonController.text = "Bekreft kode";

            await auth.verifyPhoneNumber(
                phoneNumber: "+47 " + phoneNumber,
                theId: (s) {
                  _verificationId = s;
                  signInStatus = SignInStatus.enterCode;

                  _saveButtonController.isLoading = false;
                  _saveButtonController.setState(() {});
                  setState(() {});
                });
          } else if (validateTextFields(singleTextField: textFields[1])) {
            _saveButtonController.isLoading = true;
            _saveButtonController.setState(() {});
            setState(() {});
            rootPageController.firebaseUser =
                await auth.signInWithPhone(_verificationId, _smsCode);
            if (rootPageController.firebaseUser != null) {
              rootPageController.getUserContext().then((v) {
                Navigator.pop(context);
              });
            } else {
              onError();
            }
            // Might not be needed
            // _saveButtonController.isLoading = false;
            // _saveButtonController.setState(() {});
          }
        } catch (e) {
          onError();
        }
      },
    );
    textFields = [
      PrimaryTextField(
        asListTile: true,
        prefixText: "+47 ",
        hintText: "Telefonnummer",
        key: Key("number"),
        textInputType: TextInputType.phone,
        autoFocus: true,
        validate: true,
        onSaved: (val) => phoneNumber = val.trim(),
        regExType: RegExType.phone,
      ),
      PrimaryTextField(
        asListTile: true,
        regExType: RegExType.smsCode,
        key: Key("code"),
        hintText: "Kode",
        initValue: _smsCode,
        textInputType: TextInputType.number,
        autoFocus: true,
        validate: true,
        onSaved: (val) => _smsCode = val.trim(),
      ),
    ];
    super.initState();
  }

  void onError() {
    _saveButtonController.isLoading = false;
    _saveButtonController.setState(() {});
    // signInStatus = SignInStatus.enterNumber;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;

  @override
  Widget get bottomNav => null;

  @override
  FloatingActionButton get fab => null;

  @override
  String get title => "Logg inn";
}

class PhoneLogin extends MasterPage {
  final PhoneLoginController controller;

  PhoneLogin({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    return Form(
      key: controller.formKey,
      child: Column(
        children: <Widget>[
          Container(
            height: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 15),
          ),
          if (controller.signInStatus == SignInStatus.enterNumber) ...[
            controller.textFields[0]
          ] else ...[
            controller.textFields[1]
          ],
          PrimaryButton(
            controller: controller._saveButtonController,
          ),
          termsAndConditions(context),
        ],
      ),
    );
  }
}
