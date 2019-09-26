import 'dart:async';
import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailLoginController extends BaseController {
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
      // if (e.message ==
      //         "The password is invalid or the user does not have a password." ||
      //     e.message ==
      //         "There is no user record corresponding to this identifier. The user may have been deleted.") {
      //   authHint = "Feil email eller passord";
      // } else if (e.message == "The email address is badly formatted.") {
      //   authHint = "Email-adressen er feil formatert";
      // }
      // setAuthHint(authHint);
      // print(authHint);
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
}

class EmailLogin extends BaseView {
  final EmailLoginController controller;

  EmailLogin({this.controller});

  @override
  Widget build(BuildContext context) {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          elevation: 0,
          title: Text(
            controller.isLogin ? "LOGG INN" : "REGISTRER",
            style: ServiceProvider
                .instance.instanceStyleService.appStyle.pageTitle,
          ),
          // bottom: PreferredSize(
          //     preferredSize: Size(0, 0),
          //     child: Divider(
          //       color: ServiceProvider
          //           .instance.instanceStyleService.appStyle.textGrey,
          //     )),
        ),
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: FocusScope(
              node: controller._node,
              child: Column(
                children: <Widget>[
                  controller.textFields[0],
                  controller.textFields[1],
                  if (!controller.isLogin) ...[
                    controller.textFields[2],
                  ],
                  Container(
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 90),
                    child: Text(
                      controller.authHint,
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.timestamp,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PrimaryButton(
                    controller: controller.primaryButtonController,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.isLogin = !controller.isLogin;
                      controller.setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 50),
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.green,
                      ),
                      child: Text(
                        controller.isLogin ? "Registrer deg" : "Logg inn",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.buttonText,
                      ),
                    ),
                  ),
                  Container(
                    height: getDefaultPadding(context) * 4,
                  ),
                  termsAndConditions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
