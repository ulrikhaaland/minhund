import 'package:flutter/material.dart';
import 'dart:math';

enum ScreenSizeDefinition { small, medium, big, veryBig }

class ScreenService {
  ScreenSizeDefinition getScreenSizeDefinition(BuildContext context) {
    double height = getHeight(context);
    double width = getWidth(context);

    if (width > height) {
      final double w = height;

      /// Shuffle the sizes so that
      /// the height is the biggest
      height = width;
      width = w;
    }

    if (height > 1600 && width > 1100) {
      return ScreenSizeDefinition.veryBig;
    } else if (height > 1200 && width > 700) {
      return ScreenSizeDefinition.big;
    } else if (width > 700) {
      return ScreenSizeDefinition.medium;
    }

    return ScreenSizeDefinition.small;
  }

  ScreenSizeDefinition getScreenWidthDefinition(BuildContext context) {
    double width = getWidth(context);
    if (width > 1800) {
      return ScreenSizeDefinition.veryBig;
    } else if (width > 1200) {
      return ScreenSizeDefinition.big;
    } else if (width > 700) {
      return ScreenSizeDefinition.medium;
    }

    return ScreenSizeDefinition.small;
  }

  ScreenSizeDefinition getScreenHeightDefinition(BuildContext context) {
    double height = getHeight(context);

    if (height > 1800) {
      return ScreenSizeDefinition.veryBig;
    } else if (height > 1200) {
      return ScreenSizeDefinition.big;
    } else if (height > 700) {
      return ScreenSizeDefinition.medium;
    }

    return ScreenSizeDefinition.small;
  }

  double getInches(BuildContext context) {
    double height = getHeight(context);
    double width = getWidth(context);
    double dpi = MediaQuery.of(context).textScaleFactor;

    print(height);
    print(width);
    print(dpi);

    return sqrt(((pow(height / dpi, 2)) + (pow(width / dpi, 2))));
  }

  double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getPortraitHeight(BuildContext context) {
    if (isLandscape(context))
      return MediaQuery.of(context).size.width;
    else
      return MediaQuery.of(context).size.height;
  }

  double getHeightByPercentage(BuildContext context, double percentage) {
    /// Might have passed 0.1 = 10% for instance
    if (percentage < 1.0) {
      percentage = percentage * 100;
    }

    return getHeight(context) * (percentage / 100);
  }

  double getPortraitHeightByPercentage(
      BuildContext context, double percentage) {
    /// Might have passed 0.1 = 10% for instance
    if (percentage < 1.0) {
      percentage = percentage * 100;
    }

    if (isLandscape(context))
      return MediaQuery.of(context).size.width * (percentage / 100);
    else
      return MediaQuery.of(context).size.height * (percentage / 100);
  }

  double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double getPortraitWidth(BuildContext context) {
    if (isLandscape(context))
      return MediaQuery.of(context).size.height;
    else
      return MediaQuery.of(context).size.width;
  }

  double getWidthByPercentage(BuildContext context, double percentage) {
    /// Might have passed 0.1 = 10% for instance
    if (percentage < 1.0) {
      percentage = percentage * 100;
    }

    return getWidth(context) * (percentage / 100);
  }

  double getPortraitWidthByPercentage(BuildContext context, double percentage) {
    /// Might have passed 0.1 = 10% for instance
    if (percentage < 1.0) {
      percentage = percentage * 100;
    }
    if (isLandscape(context))
      return MediaQuery.of(context).size.height * (percentage / 100);
    else
      return MediaQuery.of(context).size.width * (percentage / 100);
  }

  bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  double getBambooFactor(BuildContext context) {
    ScreenSizeDefinition definition = getScreenSizeDefinition(context);

    switch (definition) {
      case ScreenSizeDefinition.veryBig:
        return 0.7;
      case ScreenSizeDefinition.big:
        return 0.8;
      case ScreenSizeDefinition.medium:
      case ScreenSizeDefinition.small:
      default:
        return 1.0;
    }
  }
}
