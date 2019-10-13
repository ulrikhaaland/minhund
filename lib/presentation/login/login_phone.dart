import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/root_page.dart';
import 'package:flutter/material.dart';
import 'package:minhund/utilities/master_page.dart';

enum SignInStatus { enterNumber, enterCode }

class PhoneLoginController extends MasterPageController {
  final BaseAuth auth;

  final formKey = GlobalKey<FormState>();

  String _smsCode = "";
  String _verificationId;

  SignInStatus signInStatus = SignInStatus.enterNumber;

  String phoneNumber = "";

  PrimaryButtonController _btnCtrlr;

  final RootPageController rootPageController;

  List<PrimaryTextField> textFields;

  PhoneLoginController({
    this.auth,
    this.rootPageController,
  });

  @override
  void initState() {
    _btnCtrlr = PrimaryButtonController(
      text: "Send meg engangskode på SMS",
      onPressed: () async {
        formKey.currentState.save();
        try {
          if (signInStatus != SignInStatus.enterCode &&
              validateTextFields(singleTextField: textFields[0])) {
            _btnCtrlr.isLoading = true;
            _btnCtrlr.setState(() {});
            _btnCtrlr.text = "Bekreft kode";

            await auth.verifyPhoneNumber(
                phoneNumber: "+47 " + phoneNumber,
                theId: (s) {
                  _verificationId = s;
                  signInStatus = SignInStatus.enterCode;

                  _btnCtrlr.isLoading = false;
                  _btnCtrlr.setState(() {});
                  setState(() {});
                });
          } else if (validateTextFields(singleTextField: textFields[1])) {
            _btnCtrlr.isLoading = true;
            _btnCtrlr.setState(() {});
            setState(() {});
            rootPageController.firebaseUser =
                await auth.signInWithPhone(_verificationId, _smsCode);
            if (rootPageController.firebaseUser != null) {
              rootPageController.getUser().then((v) {
                Navigator.pop(context);
              });
            } else {
              onError();
            }
            // Might not be needed
            // _btnCtrlr.isLoading = false;
            // _btnCtrlr.setState(() {});
          }
        } catch (e) {
          onError();
        }
      },
    );
    textFields = [
      PrimaryTextField(
        hintText: "Telefonnummer",
        key: Key("number"),
        // initValue: phoneNumber,
        textInputType: TextInputType.phone,
        textAlign: TextAlign.center,
        autoFocus: true,
        validate: true,
        onSaved: (val) => phoneNumber = val.trim(),
        regExType: RegExType.phone,
      ),
      PrimaryTextField(
        regExType: RegExType.smsCode,
        key: Key("code"),
        hintText: "Kode",
        initValue: _smsCode,
        textInputType: TextInputType.number,
        textAlign: TextAlign.center,
        autoFocus: true,
        validate: true,
        onSaved: (val) => _smsCode = val.trim(),
      ),
    ];
    super.initState();
  }

  void onError() {
    _btnCtrlr.isLoading = false;
    _btnCtrlr.setState(() {});
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
  Widget get actionTwo => null;

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

    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          children: <Widget>[
            Container(
              height: getDefaultPadding(context) * 2,
            ),
            if (controller.signInStatus == SignInStatus.enterNumber) ...[
              controller.textFields[0]
            ] else ...[
              controller.textFields[1]
            ],
            PrimaryButton(
              controller: controller._btnCtrlr,
            ),
            termsAndConditions(context),
          ],
        ),
      ),
    );
  }
}
