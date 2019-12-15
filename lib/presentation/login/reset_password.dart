import 'package:flutter/material.dart';
import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

enum ResetPasswordState { init, sent, reSent }

class ResetPasswordController extends MasterPageController {
  final BaseAuth auth;

  ResetPasswordController({this.auth});
  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;

  @override
  Widget get bottomNav => null;

  @override
  FloatingActionButton get fab => null;

  @override
  String get title {
    if (resetPasswordState == ResetPasswordState.init) {
      return "Glemt Passord";
    } else {
      return "Link sendt";
    }
  }

  PrimaryTextField textField;

  String email;

  ResetPasswordState resetPasswordState = ResetPasswordState.init;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    textField = PrimaryTextField(
      asListTile: true,
      validate: true,
      regExType: RegExType.email,
      hintText: "Email",
      textCapitalization: TextCapitalization.none,
      textInputType: TextInputType.emailAddress,
      onSaved: (val) => email = val.trim().toLowerCase(),
    );
    super.initState();
  }

  Future<void> sendResetLink() {
    return auth.resetPassword(email);
  }

  @override
  // TODO: implement enabledTopSafeArea
  bool get enabledTopSafeArea => null;
}

class ResetPassword extends MasterPage {
  final ResetPasswordController controller;

  ResetPassword({this.controller});
  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          children: <Widget>[
            if (controller.resetPasswordState == ResetPasswordState.sent ||
                controller.resetPasswordState == ResetPasswordState.reSent) ...[
              Icon(
                Icons.check,
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.skyBlue,
                size: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 20),
              ),
              Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 90),
                child: Text(
                  "Vi har sendt en deg link med tilbakestilling av passord. Sjekk din innboks og følg linken for å lage et nytt passord.",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.body1,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: getDefaultPadding(context) * 4,
              ),
              InkWell(
                onTap: () {
                  controller.sendResetLink();
                  controller.setState(() => controller.resetPasswordState =
                      ResetPasswordState.reSent);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        controller.resetPasswordState == ResetPasswordState.sent
                            ? "Fikk du ingen email? "
                            : "Emailen har blitt sendt igjen",
                        style: ServiceProvider.instance.instanceStyleService
                            .appStyle.disabledColoredText,
                      ),
                      if (controller.resetPasswordState ==
                          ResetPasswordState.sent)
                        Text(
                          "Send på nytt",
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.coloredText,
                        ),
                    ],
                  ),
                ),
              )
            ] else ...[
              controller.textField,
              PrimaryButton(
                controller: PrimaryButtonController(
                  text: "Tilbakestill passord",
                  onPressed: () => controller.setState(() {
                    controller.formKey.currentState.save();
                    if (validateTextFields(
                        singleTextField: controller.textField)) {
                      controller.resetPasswordState = ResetPasswordState.sent;
                      controller.sendResetLink();
                    }
                  }),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
