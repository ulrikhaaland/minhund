import 'dart:async';
import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
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

    super.initState();
  }

  @override
  dispose() {
    _node.dispose();
    super.dispose();
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
    } else {}
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
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement fab
  FloatingActionButton get fab => null;

  @override
  // TODO: implement title
  String get title => isLogin ? "Logg inn" : "Registrer";
}

class EmailLogin extends MasterPage {
  final EmailLoginController controller;

  EmailLogin({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    controller.textFields = controller.textFields = <PrimaryTextField>[
      PrimaryTextField(
        regExType: RegExType.email,
        hintText: "Email",
        textCapitalization: TextCapitalization.none,
        textInputType: TextInputType.emailAddress,
        onFieldSubmitted: () => controller._node.nextFocus(),
        onSaved: (val) => controller.email = val.trim().toLowerCase(),
      ),
      PrimaryTextField(
        regExType: RegExType.password,
        hintText: "Passord",
        onFieldSubmitted: () => controller.isLogin
            ? controller._node.unfocus()
            : controller._node.nextFocus(),
        obscure: true,
        textCapitalization: TextCapitalization.none,
        textInputAction:
            controller.isLogin ? TextInputAction.done : TextInputAction.next,
        onSaved: (val) => controller.password = val.trim().toLowerCase(),
      ),
      PrimaryTextField(
        regExType: RegExType.password,
        hintText: "Bekreft passord",
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.done,
        obscure: true,
        onFieldSubmitted: () => controller._node.unfocus(),
        onSaved: (val) => controller.confirmPassword = val.trim().toLowerCase(),
      ),
    ];

    return SingleChildScrollView(
      child: Form(
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
                  width: ServiceProvider.instance.screenService
                      .getWidthByPercentage(context, 90),
                  child: Text(
                    controller.authHint,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.cancel,
                    textAlign: TextAlign.center,
                  ),
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
                  onPressed: () {
                    controller.isLogin = !controller.isLogin;
                    controller.setState(() {});
                  },
                  text: controller.isLogin ? "Registrer deg" : "Logg inn",
                  bottomPadding: controller.isLogin ? 0 : null,
                ),
                if (controller.isLogin)
                  FlatButton(
                    child: Text(
                      "Glemt passord?",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                    ),
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
                termsAndConditions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
