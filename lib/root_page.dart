import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minhund/bottom_navigation.dart';
import 'package:minhund/helper/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/animation/intro.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/intro/user_intro.dart';
import 'package:minhund/presentation/login/login_page.dart';
import 'package:minhund/provider/dog_provider.dart';
import 'package:minhund/provider/user_provider.dart';
import 'model/user.dart';
import 'presentation/base_view.dart';
import 'service/service_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum AuthState {
  notAuthenticated,
  authenticating,
  authenticated,
  anon,
}

class RootPageController extends BaseController {
  final BaseAuth auth = Auth();

  Firestore firestoreInstance = Firestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  FirebaseUser firebaseUser;

  User _user;
  bool introDone = false;

  bool newUser = false;

  @override
  void initState() {
    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called");
      // handleMessage(msg);
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");
      // handleMessage(msg);
    }, onMessage: (Map<String, dynamic> msg) {
      var values = msg["notification"];
      BotToast.showAttachedWidget(
          attachedBuilder: (_) => Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Card(
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ServiceProvider
                            .instance
                            .instanceStyleService
                            .appStyle
                            .borderRadius),
                      ),
                      child: Container(
                        width: ServiceProvider.instance.screenService
                            .getWidthByPercentage(context, 80),
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                values["title"],
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.smallTitle,
                              ),
                              Text(
                                values["body"],
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          duration: Duration(seconds: 2),
          target: Offset(520, 520));
      print("onMessage DASD");
    });
    firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    ));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("IOS Setting Registered");
    });
    getUser();

    super.initState();
  }

  @override
  void dispose() {
    print('RootPage: dispose');
    super.dispose();
  }

  Future<Null> getUser() async {
    if (firebaseUser == null) {
      firebaseUser = await auth.currentUser();
    }

    if (firebaseUser != null) {
      _user = await UserProvider().get(
        id: firebaseUser.uid,
      );
      if (_user == null) {
        _user = User(
            email: firebaseUser.email == "" ? null : firebaseUser.email,
            id: firebaseUser.uid == "" ? null : firebaseUser.uid,
            fcm: null,
            allowsNotifications: false,
            appVersion: 1,
            notifications: 0,
            phoneNumber: firebaseUser.phoneNumber,
            dogs: [],
            currentDogIndex: 0);

        newUser = true;
        await UserProvider().set(id: _user.id, model: _user);
        _user = await UserProvider().get(
          id: _user.id,
        );
        refresh();
      } else {
        DogProvider().getCollection(id: firebaseUser.uid).then((dogs) {
          _user.dogs = dogs ?? [];
          refresh();
        });
      }
      UserProvider().updateFcmToken(_user, firebaseMessaging);
    }

    refresh();
    return;
  }

  Future asAnon() async {
    firebaseUser = await auth.asAnon();
    refresh();
  }
}

class RootPage extends BaseView {
  final RootPageController controller;

  RootPage({this.controller, Key key})
      : super(
          controller: controller,
        );

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container();
    }

    /// Force the app bar to be "white" so that the time,
    /// battery and all those symbols are rendered as black
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white));

    /// Make sure that a style is set which is
    /// also based on the dimensions of the context
    /// whom can be fetched here. The default style
    /// can only be set one during the applications
    /// lifetime so re-render of this page will not
    /// set the style every time since the style service
    /// has an internal control of that
    ///
    ServiceProvider.instance.instanceStyleService.setStandardStyle(
      ServiceProvider.instance.screenService.getPortraitHeight(context),
      ServiceProvider.instance.screenService.getBambooFactor(context),
    );

    // controller.auth.signOut();

    if (!controller.introDone) {
      return Intro(
        introDone: () {
          controller.introDone = true;
          controller.refresh();
        },
      );
    } else if (controller.firebaseUser == null) {
      return LoginPage(
        controller: LoginPageController(
          rootPageController: controller,
          auth: controller.auth,
          returnUser: (returnUser) {
            if (returnUser != null) {
              controller.firebaseUser = returnUser;
              controller.refresh();
            }
            return returnUser;
          },
        ),
      );
    } else if (controller.newUser && controller._user != null) {
      return UserIntro(
        controller: UserIntroController(
            user: controller._user,
            onIntroFinished: () =>
                controller.setState(() => controller.newUser = false)),
      );
    } else if (controller._user != null) {
      controller._user.dog =
          controller._user.dogs[controller._user.currentDogIndex];

      return BottomNavigation(
        controller: BottomNavigationController(
          user: controller._user,
        ),
      );
    }
    return Container();
  }
}
