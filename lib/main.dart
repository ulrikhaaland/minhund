import 'package:flutter/services.dart';
import 'package:minhund/root_page.dart';
import './service/instance_style_service.dart';
import './service/theme_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import './service/service_provider.dart';
import './service/screen_service.dart';
import 'package:bot_toast/bot_toast.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 233, 242, 248), //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons
    systemNavigationBarColor:
        Color.fromARGB(255, 233, 242, 248), //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));
  ServiceProvider.instance.screenService = ScreenService();
  ServiceProvider.instance.instanceStyleService = InstanceStyleService();
  ServiceProvider.instance.themeService = ThemeService();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App());
}

class App extends StatefulWidget {
  final RootPageController _rootController = RootPageController();
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    if (!(mounted ?? false)) {
      return Container();
    }

    print('App: build');
    return BotToastInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          iconTheme: IconThemeData(
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.textGrey),
          // brightness: Brightness.light,
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          primarySwatch: Colors.grey,
        ),
        home: RootPage(
          controller: widget._rootController,
        ),
        routes: {
          "/home": (BuildContext c) => RootPage(
                controller: widget._rootController,
              ),
        },
      ),
    );
  }
}
