import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/service/theme_service.dart';

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

bool validateTextFields(
    {List<PrimaryTextField> textFields, PrimaryTextField singleTextField}) {
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

Widget termsAndConditions() {
  return Column(
    children: <Widget>[
      Text(
        "Ved å registrere bruker hos Minhund samtykker jeg til Minhund's",
        style: ServiceProvider.instance.instanceStyleService.appStyle.timestamp,
        textAlign: TextAlign.start,
      ),
      InkWell(
        onTap: () => print("GO TO TERMS AND CONDITIONS"),
        child: Text(
          "brukervilkår.",
          style: ServiceProvider
              .instance.instanceStyleService.appStyle.coloredText,
          textAlign: TextAlign.start,
        ),
      ),
    ],
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

String getTimeDifference(DateTime time) {
  String difference;

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

class KpiProgressColor {
  final Color color;
  final ProgressStatus status;

  KpiProgressColor(this.color, this.status);
}

KpiProgressColor getKPIColorByPercentage(double percentage) {
  ProgressStatus status;

  double value = percentage ?? 0.0;

  if (value == 0.0) {
    status = ProgressStatus.undefined;
  } else if (value >= 120.0) {
    status = ProgressStatus.veryGood;
  } else if (value >= 100.0) {
    status = ProgressStatus.good;
  } else if (value >= 80.0) {
    status = ProgressStatus.bad;
  } else if (value >= 80.0) {
    status = ProgressStatus.bad;
  } else {
    status = ProgressStatus.veryBad;
  }

  return KpiProgressColor(
      ServiceProvider.instance.themeService.getColorForProgressStatus(status),
      status);
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

Future<void> showBambooDialog({
  BuildContext context,
  Widget child,
}) async {
  double height = ServiceProvider.instance.screenService
      .getHeightByPercentage(context, 80.0);
  double width = ServiceProvider.instance.screenService
      .getWidthByPercentage(context, 80.0);
  return await showDialog(
    context: context,
    builder: (con) {
      return Dialog(
        child: Container(
          width: width,
          height: height,
          child: child,
        ),
      );
    },
  );
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
