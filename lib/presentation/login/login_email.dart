import 'dart:async';
import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/login/reset_password.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minhund/utilities/master_page.dart';

class EmailLoginController extends MasterPageController {
  bool isLogin = true;

  final BaseAuth auth;

  PrimaryButtonController primaryButtonController;

  final VoidCallback returnUser;

  final formKey = GlobalKey<FormState>();

  FocusScopeNode _node = FocusScopeNode();

  String email;
  String password;
  String confirmPassword;

  String uid;

  String authHint = "";

  List<PrimaryTextField> textFields;

  EmailLoginController({this.auth, this.returnUser});

  @override
  void initState() {
    primaryButtonController = PrimaryButtonController(
        text: "Bekreft",
        onPressed: () async {
          primaryButtonController.setState(() {
            primaryButtonController.isLoading = true;
            authHint = "";
          });
          await validateAndSave();
          primaryButtonController.setState(() {
            primaryButtonController.isLoading = false;
          });
        },
        color: ServiceProvider.instance.instanceStyleService.appStyle.skyBlue);

    buildTextFields();

    super.initState();
  }

  @override
  dispose() {
    _node.dispose();
    super.dispose();
  }

  void buildTextFields() {
    textFields = <PrimaryTextField>[
      PrimaryTextField(
        asListTile: true,
        validate: true,
        regExType: RegExType.email,
        hintText: "Email",
        textCapitalization: TextCapitalization.none,
        textInputType: TextInputType.emailAddress,
        onFieldSubmitted: () => _node.nextFocus(),
        onSaved: (val) => email = val.trim().toLowerCase(),
      ),
      PrimaryTextField(
        asListTile: true,
        validate: true,
        regExType: RegExType.password,
        hintText: "Passord",
        onFieldSubmitted: () => isLogin ? _node.unfocus() : _node.nextFocus(),
        obscure: true,
        textCapitalization: TextCapitalization.none,
        textInputAction: isLogin ? TextInputAction.done : TextInputAction.next,
        onSaved: (val) => password = val,
      ),
      PrimaryTextField(
        asListTile: true,
        validate: true,
        regExType: RegExType.password,
        hintText: "Bekreft passord",
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.done,
        obscure: true,
        onFieldSubmitted: () => _node.unfocus(),
        onSaved: (val) => confirmPassword = val,
      ),
    ];
  }

  Future<bool> validateAndSave() async {
    bool consensus = false;

    formKey.currentState.save();

    if (isLogin
        ? validateTextFields(textFields: [
            textFields[0],
            textFields[1],
          ])
        : validateTextFields(textFields: textFields)) {
      uid = await loginOrRegister();
      if (uid == null) {
        consensus = false;
      } else {
        returnUser();

        consensus = true;
      }
    }
    return consensus;
  }

  Future<String> loginOrRegister() async {
    String userId;
    try {
      if (isLogin) {
        userId = await auth.signIn(email, password);
      } else {
        if (password == confirmPassword) {
          userId = await auth.createUser(email, password);
        } else {
          setAuthHint("Passordene stemmer ikke overens");
        }
      }
    } catch (e) {
      if (e.message ==
              "The password is invalid or the user does not have a password." ||
          e.message ==
              "There is no user record corresponding to this identifier. The user may have been deleted.") {
        authHint = "Feil email eller passord";
      } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        authHint = "Email-adressen er allerede i bruk";
      }
      setAuthHint(authHint);
      print(authHint);
    }
    return userId;
  }

  setAuthHint(String hintText) {
    authHint = hintText;
    setState(() {});
    // Timer(Duration(seconds: 3), () {
    //   authHint = "";
    //   setState(() {});
    // });
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
  String get title => isLogin ? "Logg inn" : "Registrer";

  @override
  bool get enabledTopSafeArea => null;

  @override
  bool get hasBottomNav => false;

  @override
  // TODO: implement disableResize
  bool get disableResize => null;
}

class EmailLogin extends MasterPage {
  final EmailLoginController controller;

  EmailLogin({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: FocusScope(
        node: controller._node,
        child: Container(
          alignment: Alignment.center,
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 90),
          child: Column(
            children: <Widget>[
              Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 5),
              ),
              Text(
                controller.authHint,
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.cancel,
                textAlign: TextAlign.center,
              ),
              Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 0.02),
              ),
              controller.textFields[0],
              controller.textFields[1],
              if (!controller.isLogin) ...[
                controller.textFields[2],
              ],
              PrimaryButton(
                controller: controller.primaryButtonController,
              ),
              SecondaryButton(
                bottomPadding: 0,
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 70),
                onPressed: () {
                  controller.setState(() {
                    controller.isLogin = !controller.isLogin;
                    controller.buildTextFields();
                    FocusScope.of(context).unfocus();
                  });
                },
                text: controller.isLogin ? "Registrer deg" : "Logg inn",
              ),
              if (controller.isLogin)
                SecondaryButton(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 4.5),
                  width: ServiceProvider.instance.screenService
                      .getWidthByPercentage(context, 40),
                  color: Colors.white,
                  textColor: ServiceProvider
                      .instance.instanceStyleService.appStyle.textGrey,
                  text: "Glemt passord?",
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassword(
                          controller: ResetPasswordController(
                            auth: controller.auth,
                          ),
                        ),
                      )),
                ),
              if (!controller.isLogin)
                Padding(
                  padding:
                      EdgeInsets.only(top: getDefaultPadding(context) * 2),
                  child: termsAndConditions(context),
                ),
                Spacer(),
              webLink,
              Container(
                height: getDefaultPadding(context) * 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
