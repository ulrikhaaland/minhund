import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/service/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

double getAppBarIconSize(BuildContext context) {
  /// Only initialize once since the screen dimensions
  /// will never change during a session
  if (_appBarIconSize == null) {
    _appBarIconSize = ServiceProvider.instance.screenService
        .getPortraitHeightByPercentage(context, 0.03);

    if (_appBarIconSize > 35.0) {
      _appBarIconSize = 35.0;
    }
  }

  return _appBarIconSize;
}

double _appBarIconSize;

enum PageState { create, edit, read }

double getContainerSize({GlobalKey key, bool width}) {
  final RenderBox renderBoxRed = key.currentContext.findRenderObject();
  final sizeRed = renderBoxRed.size;
  print(sizeRed.width);
  if (width) {
    return sizeRed.width;
  } else if (!width) {
    return sizeRed.height;
  }
}

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus != null ? currentFocus.unfocus() : null;
  FocusScope.of(context).requestFocus(nextFocus);
}

bool validateTextFields({List<dynamic> textFields, dynamic singleTextField}) {
  bool canSave = true;
  if (singleTextField == null) {
    textFields.forEach((field) {
      if (field.canSave == false) {
        canSave = false;
      }
    });
  } else {
    canSave = singleTextField.canSave;
  }
  return canSave;
}

String formatDate({String format, bool time, DateTime date}) {
  if (date == null) return null;
  if (time == true) {
    return "${date.hour.toString().length < 2 ? "0" + date.hour.toString() : date.hour.toString()}:${date.minute.toString().length < 2 ? "0" + date.minute.toString() : date.minute.toString()}";
  } else {
    String month;
    date.month.toString().length == 1
        ? month = "0" + date.month.toString()
        : month = date.month.toString();

    if (date == null) {
      return "";
    } else {
      switch (format) {
        case ("dd.MM.yyyy"):
          return "${date.day.toString().length < 2 ? "0" + date.day.toString() : date.day.toString()}-${date.month.toString().length < 2 ? "0" + date.month.toString() : date.month.toString()}-${date.year}";
          break;
        case ("MM-yyyy"):
          return "${date.month.toString().length < 2 ? "0" + date.month.toString() : date.month.toString()}-${date.year}";
          break;

        default:
          return "${date.day.toString().length < 2 ? "0" + date.day.toString() : date.day.toString()}.${date.month.toString().length < 2 ? "0" + date.month.toString() : date.month.toString()}.${date.year}";
      }
    }
  }
}

Future<void> launchUrl({String url}) async {
  if (url != null && url != "") {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Widget termsAndConditions(BuildContext context) {
  return Container(
    width: ServiceProvider.instance.screenService
        .getWidthByPercentage(context, 90),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style:
              ServiceProvider.instance.instanceStyleService.appStyle.timestamp,
          children: [
            TextSpan(
              text:
                  "Ved å registrere bruker hos Minhund samtykker jeg til Minhund's ",
            ),
            TextSpan(
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.timestamp
                    .copyWith(
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.leBleu),
                text: "brukervilkår",
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(url: "https://mihu.no/terms")),
            TextSpan(text: " og "),
            TextSpan(
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.timestamp
                    .copyWith(
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.leBleu),
                text: "personvernpolicy.",
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(url: "https://mihu.no/privacy")),
          ]),
    ),
  );
}

double getCircleAvatarSize(BuildContext context) {
  /// Only initialize once since the screen dimensions
  /// will never change during a session
  if (_avatarCircleSize == null) {
    _avatarCircleSize = ServiceProvider.instance.screenService
        .getPortraitHeightByPercentage(context, 0.09);
  }

  return _avatarCircleSize;
}

double _avatarCircleSize;

double getCircleAvatarBorderSize(BuildContext context) {
  /// Only initialize once since the screen dimensions
  /// will never change during a session
  if (_avatarCircleBorderSize == null) {
    _avatarCircleBorderSize = ServiceProvider.instance.screenService
        .getPortraitHeightByPercentage(context, 0.005);
  }

  return _avatarCircleBorderSize;
}

void scrollScreen(
    {double height,
    ScrollController controller,
    int scrollDuration,
    int timeBeforeAction}) {
  Timer(Duration(milliseconds: timeBeforeAction ?? 100), () {
    controller.position.moveTo(height ?? 100,
        duration: Duration(milliseconds: scrollDuration ?? 300));
  });
}

String formatDifference({DateTime date1, DateTime date2, bool futureString}) {
  int diff = date1.difference(date2).inDays.abs();

  String returnString = "";

  if (diff > 365) {
    String months = "";
    if (((diff % 365) / 30.42).truncate() > 0)
      months =
          "${((diff % 365) / 30.42).truncate()} ${((diff % 365) / 30.42).truncate() != 1 ? "måneder" : "måned"}";
    returnString =
        "${(diff / 365).truncate()} år ${months != "" ? "og " + months : ''}";
  } else if (diff > 0) {
    returnString =
        "${(diff).truncate()} ${diff != 1 ? "dager" : "dag"} og ${(diff % 24)} ${(diff % 24) != 1 ? "timer" : "time"}";
  } else {
    diff = date1.difference(date2).inMinutes.abs();
    if (diff > 60) {
      returnString =
          "${(diff / 60).truncate()} ${(diff / 60).truncate() != 1 ? "timer" : "time"} og ${(diff % 60)} ${(diff % 60) != 1 ? "minutter" : "minutt"}";
    } else if (diff > 0) {
      returnString = "$diff ${diff != 1 ? "minutter" : "minutt"}";
    } else if (diff == 0) {
      returnString = "mindre enn 1 min";
    }
  }
  if (futureString == true) return "om " + returnString;
  // I.E pastString
  if (futureString == false) return returnString + " siden";
  return returnString;
}

String getTimeDifference({DateTime time, bool daysMonthsYears}) {
  String difference;
  if (daysMonthsYears) {
    int days = DateTime.now().difference(time).inDays.abs();
    if (days > 365) {
      if (days < 730) {
        return "1 år";
      }
      int years = (days / 365).round();
      days = (days % 365).round();
      return "$years år";
    } else {
      return " ${(days % 365).round().abs()} dager";
    }
  } else {
    double days;
    int hours;
    int minutes;
    int seconds;

    hours = time.difference(DateTime.now()).inHours.abs();
    minutes = time.difference(DateTime.now()).inMinutes.abs();
    seconds = time.difference(DateTime.now()).inSeconds.abs();

    if (hours != 0) {
      days = hours / 24;
      if (days < 1) {
        difference = "${hours.abs()} t";
      } else {
        if (days > 2) {
          difference = "${time.day}.${time.month}.${time.year}";
        } else {
          difference = "${days.abs().round()} d";
        }
      }
    } else if (minutes != 0) {
      difference = "$minutes m";
    } else {
      difference = "$seconds s";
    }

    return difference ?? "N/A";
  }
}

double _avatarCircleBorderSize;

double getListItemHeight(BuildContext context) {
  if (_listItemHeight == null) {
    double percentage = 15.0;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      percentage = 17.0;
    }

    double listHeight = ServiceProvider.instance.screenService
        .getPortraitHeightByPercentage(context, percentage);

    _listItemHeight = listHeight < 110.0 ? 110.0 : listHeight;
  }

  return _listItemHeight;
}

double _listItemHeight;

double getMinimizedListItemHeight(BuildContext context) {
  double percentage = 7.0;

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    percentage = 7.0;
  }

  double listHeight = ServiceProvider.instance.screenService
      .getPortraitHeightByPercentage(context, percentage);

  return listHeight < 55.0 ? 55.0 : listHeight;
}

double _listItemImageWidth;

double getListItemImageWidth(BuildContext context) {
  if (_listItemImageWidth == null) {
    _listItemImageWidth = ServiceProvider.instance.screenService
        .getPortraitWidthByPercentage(context, 30.0);
  }

  return _listItemImageWidth;
}

double getReportHeaderHeight(BuildContext context) {
  return ServiceProvider.instance.screenService
      .getPortraitHeightByPercentage(context, 6.0);
}

double _bigIconSize;

double getBigIconSize(BuildContext context) {
  if (_bigIconSize == null) {
    _bigIconSize = ServiceProvider.instance.screenService
        .getPortraitWidthByPercentage(context, 10.0);
  }

  return _bigIconSize;
}

double getDefaultPadding(BuildContext context) {
  /// Only initialize once since the screen dimensions
  /// will never change during a session
  if (_defaultPadding == null) {
    _defaultPadding = ServiceProvider.instance.screenService
        .getPortraitHeightByPercentage(context, 0.006);

    if (_defaultPadding > 10.0) {
      _defaultPadding = 10.0;
    }
  }

  return _defaultPadding;
}

double _defaultPadding;

double getDefaultButtonHeight(BuildContext context) {
  /// Only initialize once since the screen dimensions
  /// will never change during a session
  if (_defaultButtonHeight == null) {
    _defaultButtonHeight = ServiceProvider.instance.screenService
        .getPortraitHeightByPercentage(context, 6.0);
  }

  return _defaultButtonHeight;
}

double _defaultButtonHeight;

enum DialogSize { small, medium, large }

Future<void> showCustomDialog({
  BuildContext context,
  Widget child,
  DialogSize dialogSize,
}) async {
  double height;
  double width;
  switch (dialogSize) {
    case DialogSize.small:
      height = ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 20.0);

      width = ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 20.0);
      break;
    case DialogSize.medium:
      height = ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 60.0);

      width = ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 80.0);
      break;
    case DialogSize.large:
      height = ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 80.0);

      width = ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 80.0);
      break;
    default:
      height = ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 80.0);

      width = ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 80.0);
  }

  return await showDialog(
    context: context,
    builder: (con) {
      return Dialog(
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ServiceProvider
                  .instance.instanceStyleService.appStyle.borderRadius ??
              10),
        ),
        child: Container(
          width: width,
          height: height,
          child: child,
        ),
      );
    },
  );
}

dynamic fromMap({Map<String, dynamic> map, String key}) {
  var result;
  map.forEach((k, value) {
    if (k == key) result = value;
  });
  return result;
}

void showSizableDialog({
  BuildContext context,
  double height,
  double width,
  Widget child,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return new Dialog(
        child: new Container(
          width: width,
          height: height,
          child: child,
        ),
      );
    },
  );
}

double _goToButtonWidth;

double getGoToButtonWidth(BuildContext context) {
  double percentage = 8.0;

  if (_goToButtonWidth == null) {
    _goToButtonWidth = ServiceProvider.instance.screenService
        .getPortraitWidthByPercentage(context, percentage);
  }

  return _goToButtonWidth;
}
