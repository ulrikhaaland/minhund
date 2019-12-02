import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_email.dart';
import 'login_phone.dart';

class LoginPageController extends BaseController {
  final BaseAuth auth;

  final RootPageController rootPageController;

  final VoidCallback returnUser;

  LoginPageController({this.auth, this.returnUser, this.rootPageController});
}

class LoginPage extends BaseView {
  final LoginPageController controller;

  LoginPage({this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          elevation: 0,
        ),
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        body: LayoutBuilder(
          builder: (context, con) {
            return Container(
              height: con.maxHeight,
              child: Column(
                children: <Widget>[
                  Container(
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 5),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "LOGG INN",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                      ),
                      Text(
                        "ELLER",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                      ),
                      Text(
                        "REGISTRER DEG",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                      ),
                      Text(
                        "MED",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                      ),
                      Container(
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 5),
                        width: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneLogin(
                                      controller: PhoneLoginController(
                                          auth: controller.auth,
                                          rootPageController:
                                              controller.rootPageController),
                                    )),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 161, 196, 253),
                              borderRadius: BorderRadius.circular(
                                  ServiceProvider.instance.instanceStyleService
                                      .appStyle.borderRadius)),
                          height: ServiceProvider.instance.screenService
                              .getPortraitHeightByPercentage(context, 7.5),
                          width: ServiceProvider.instance.screenService
                              .getWidthByPercentage(context, 70),
                          child: Center(
                            child: Text(
                              "Telefon",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.buttonText,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 5),
                        width: 1,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLogin(
                                    controller: EmailLoginController(
                                        auth: controller.auth,
                                        returnUser: () async {
                                          await controller.rootPageController
                                              .getUserContext();
                                          Navigator.of(context).pop();
                                        }),
                                  )),
                        ),
                        child: Container(
                          height: ServiceProvider.instance.screenService
                              .getPortraitHeightByPercentage(context, 7.5),
                          width: ServiceProvider.instance.screenService
                              .getWidthByPercentage(context, 70),
                          decoration: BoxDecoration(
                              color: ServiceProvider
                                  .instance.instanceStyleService.appStyle.green,
                              borderRadius: BorderRadius.circular(
                                  ServiceProvider.instance.instanceStyleService
                                      .appStyle.borderRadius)),
                          child: Center(
                            child: Text(
                              "Email",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.buttonText,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 5),
                        width: 1,
                      ),

                      // InkWell(
                      //   onTap: () => controller.rootPageController.asAnon(),
                      //   child: Container(
                      //     height: ServiceProvider.instance.screenService
                      //         .getPortraitHeightByPercentage(context, 7.5),
                      //     width: ServiceProvider.instance.screenService
                      //         .getWidthByPercentage(context, 70),
                      //     decoration: BoxDecoration(
                      //       // gradient: LinearGradient(
                      //       //     colors: ServiceProvider.instance
                      //       //         .instanceStyleService.appStyle.gradient),
                      //       borderRadius: BorderRadius.circular(8),
                      //       color: Color.fromARGB(255, 161, 196, 253),
                      //       // borderRadius: BorderRadius.circular(8)
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Anonym",
                      //         style: ServiceProvider.instance.instanceStyleService
                      //             .appStyle.buttonText,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text(
                      "https://mihu.no",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.coloredText
                          .copyWith(fontSize: 25, color: Colors.grey),
                    ),
                    onPressed: () async {
                      String url = "https://mihu.no";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  Container(
                    height: getDefaultPadding(context) * 4,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
