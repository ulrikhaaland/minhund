import 'package:flutter/material.dart';
import 'package:minhund/model/app_style.dart';

class InstanceStyleService {
  AppStyle _appStyle = AppStyle();

  AppStyle _defaultAppStyle = AppStyle(
    themeColor: MaterialColor(0xFF25814E, <int, Color>{
      50: const Color(0xFF25814E),
      100: const Color(0xFF25814E),
      200: const Color(0xFF25814E),
      300: const Color(0xFF25814E),
      400: const Color(0xFF25814E),
      500: const Color(0xFF25814E),
      600: const Color(0xFF25814E),
      700: const Color(0xFF25814E),
      800: const Color(0xFF25814E),
      900: const Color(0xFF25814E),
    }),
    backgroundColor: Color.fromARGB(255, 240, 240, 240),
  );

  InstanceStyleService() {
    print('InstanceStyleService: constructor');
  }

  /// The global style for this application.
  /// The style can be instance specific such
  /// as the theme color may be the color of the
  /// company who uses the instance
  AppStyle get appStyle => (_appStyle ?? _defaultAppStyle);

  bool _standardStyleSet = false;

  void setStandardStyle(double screenHeight, double factor) {
    print('InstanceStyleService: setStandardStyle');

    _appStyle.backgroundColor = new Color.fromARGB(255, 245, 246, 247);
    _appStyle.dialogBackgroundColor = new Color.fromARGB(255, 233, 239, 245);

    _appStyle.pink = new Color.fromARGB(255, 230, 115, 153);
    _appStyle.skyBlue = new Color.fromARGB(255, 161, 196, 253);
    _appStyle.green = new Color.fromARGB(255, 120, 222, 166);
    _appStyle.imperial = new Color.fromARGB(255, 122, 149, 241);
    _appStyle.lightBlue = new Color.fromARGB(255, 191, 219, 233);
    _appStyle.leBleu = new Color.fromARGB(255, 122, 149, 241);
    _appStyle.textGrey = new Color.fromARGB(255, 63, 82, 97);
    _appStyle.card = new Color.fromARGB(255, 255, 222, 166);
    _appStyle.titleOneColor = Colors.black;
    _appStyle.gradient = [
      Color.fromARGB(255, 194, 233, 251),
      Color.fromARGB(255, 161, 196, 253),
      // Color.fromARGB(255, 255, 236, 210)
    ];

    _appStyle.palette = [
      const Color(0xFF3f5261),
      const Color(0xFF7a96f1),
      const Color(0xFFe67399),
      const Color(0xFFa1c4fd),
      const Color(0xFF78dea6),
      const Color(0xFF839acc),
    ];

    _appStyle.title = new TextStyle(
      fontSize: screenHeight * 0.040 * factor,
      fontFamily: 'Apercu',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.pageTitle = new TextStyle(
      fontSize: screenHeight * 0.028 * factor,
      fontFamily: 'Apercu',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.smallTitle = new TextStyle(
      fontSize: screenHeight * 0.026 * factor,
      fontFamily: 'Apercu',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.descTitle = new TextStyle(
      fontSize: screenHeight * 0.022 * factor,
      fontFamily: 'Apercu',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.tabBarStyle = new TextStyle(
      fontSize: screenHeight * 0.022 * factor,
      fontFamily: 'Apercu',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.skyBlue,
    );

    _appStyle.body1 = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: appStyle.textGrey,
    );

    _appStyle.transparentDisabledColoredText = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.transparent,
    );
    _appStyle.timestamp = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: appStyle.textGrey,
    );

    _appStyle.confirm = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.024 * factor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.green,
    );

    _appStyle.cancel = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.024 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.pink,
    );

    _appStyle.textFieldError = TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: Colors.white,
    );

    _appStyle.textFieldInput = TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.024 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.black,
    );

    _appStyle.body1Black = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.black,
    );

    _appStyle.body1BlackBig = new TextStyle(
      fontFamily: "Montserrat",
      fontSize: screenHeight * 0.030 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.black,
    );

    _appStyle.body1Bold = new TextStyle(
      fontSize: screenHeight * 0.024 * factor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.italic = new TextStyle(
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.textGrey,
    );

    _appStyle.body1Light = new TextStyle(
        fontSize: screenHeight * 0.024 * factor,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        color: Colors.white);

    _appStyle.body2 = new TextStyle(
      fontSize: screenHeight * 0.024 * factor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.body1Grey = new TextStyle(
      fontSize: screenHeight * 0.024 * factor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.numberHead1 = new TextStyle(
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.numberHead2 = new TextStyle(
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.textGrey,
    );

    _appStyle.textFieldLabel = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.pink,
    );

    _appStyle.label = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: appStyle.textGrey,
    );

    _appStyle.labelLight = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.pink,
    );

    _appStyle.iconFloatText = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      color: _appStyle.imperial,
    );

    _appStyle.buttonText = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.023 * factor,
      // fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      color: Colors.white,
    );

    _appStyle.coloredText = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.leBleu,
    );

    _appStyle.disabledColoredText = new TextStyle(
      fontFamily: "Apercu",
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Color.fromRGBO(63, 82, 97, 0.5),
    );

    _appStyle.iconSizeSmall = screenHeight * 0.031 * factor;

    _appStyle.iconSizeExtraSmall = screenHeight * 0.021 * factor;

    _appStyle.iconSizeStandard = screenHeight * 0.041 * factor;

    _appStyle.iconSizeBig = screenHeight * 0.051 * factor;

    _appStyle.activeIconColor = _appStyle.green;

    _appStyle.inactiveIconColor = Colors.grey[400];

    _appStyle.borderRadius = 24;

    _appStyle.elevation = 6;

    _defaultAppStyle = _appStyle;

    _standardStyleSet = true;
  }
}
