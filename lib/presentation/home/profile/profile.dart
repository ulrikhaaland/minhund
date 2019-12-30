import 'package:flutter/material.dart';
import 'package:minhund/helper/auth.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/profile/dog_profile.dart';
import 'package:minhund/presentation/home/profile/profile_settings.dart';
import 'package:minhund/presentation/home/profile/profile_subscription_segment.dart';
import 'package:minhund/presentation/home/profile/user_profile.dart';
import 'package:minhund/presentation/info/dog_info.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/expandable_card.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/root_page.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';
import '../../../bottom_navigation.dart';

class ProfilePageController extends BaseController {
  User user;

  BaseAuth auth;

  RootPageController rootPageController;

  static final ProfilePageController _instance =
      ProfilePageController._internal();

  factory ProfilePageController() {
    return _instance;
  }

  ProfilePageController._internal() {
    print("Profile Page built");
  }
}

class ProfilePage extends BaseView {
  final ProfilePageController controller;

  ProfilePage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    controller.user = Provider.of<User>(context);

    controller.auth = Provider.of<BaseAuth>(context);

    controller.rootPageController = Provider.of<RootPageController>(context);


    controller.user.isSubscribed = false;

    double padding = getDefaultPadding(context);

    double iconSizeStandard =
        ServiceProvider.instance.instanceStyleService.appStyle.iconSizeStandard;

    return Container(
      color: ServiceProvider.instance.instanceStyleService.appStyle.lightBlue,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).padding.top * 3.5,
            color: ServiceProvider
                .instance.instanceStyleService.appStyle.backgroundColor,
          ),
          Expanded(
            flex: 2,
            child: CustomPaint(
              painter: Chevron(),
              child: Column(
                children: <Widget>[
                  CustomImage(
                    key: Key(controller.user.dog.imgUrl ??
                        controller.user.dog.imageFile?.path ??
                        "asd"),
                    controller: CustomImageController(
                      imageSizePercentage: 20,
                      imgUrl: controller.user.dog.imgUrl,
                      imageFile: controller.user.dog.imageFile,
                      // edit: true,
                      withLabel: false,
                    ),
                  ),
                  Container(
                    height: padding,
                  ),
                  Text(
                    controller.user.dog.name,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.title,
                  ),
                  Text(
                    formatDifference(
                      date2: controller.user.dog.birthDate,
                      date1: DateTime.now(),
                    ),
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding * 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: null,
                              backgroundColor: ServiceProvider
                                  .instance.instanceStyleService.appStyle.pink,
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProfileSettings(
                                            controller:
                                                ProfileSettingsController(
                                              onSignOut: () {
                                                Navigator.pop(context);
                                                
                                                controller.rootPageController.signOut();
                                              },
                                              user: controller.user,
                                            ),
                                          ))),
                              child: Icon(Icons.settings,
                                  size: iconSizeStandard, color: Colors.white),
                            ),
                            // Text(
                            //   "Innstillinger",
                            //   style: ServiceProvider.instance
                            //       .instanceStyleService.appStyle.body1,
                            // )
                          ],
                        ),
                        FloatingActionButton(
                          heroTag: null,
                          backgroundColor: ServiceProvider
                              .instance.instanceStyleService.appStyle.leBleu,
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DogInfo(
                                        controller: DogInfoController(
                                            user: controller.user,
                                            dog: controller.user.dog,
                                            createOrUpdateDog:
                                                CreateOrUpdateDog.update),
                                      ))),
                          child: Icon(Icons.edit,
                              size: iconSizeStandard, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ProfileSubscriptionSegment(
              user: controller.user,
            ),
          )
        ],
      ),
    );
  }
}

class Chevron extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint();
    paint.color =
        ServiceProvider.instance.instanceStyleService.appStyle.backgroundColor;

    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
