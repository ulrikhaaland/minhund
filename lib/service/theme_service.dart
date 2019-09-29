import 'package:flutter/material.dart';
import 'package:minhund/helper/color_formatter.dart';

enum BusinessFlowType { order, actor, product, resource, meeting, campaign }

enum ProgressStatus {
  undefined,
  veryGood,
  good,
  impartial,
  bad,
  veryBad,
}

enum DashboardType {
  actorDashboard,
  productDashboard,
  productHierarchyDashboard,
  actorHierarchyDashboard,
  orderReport,
  kpiLeaderboard,
  distributionDashboard,
}

class ThemeService {
  ThemeService() {}

  static Map<ProgressStatus, Color> _progressStatusColors = {
    ProgressStatus.undefined: Color(ColorFormatter.hexToInt("#CCCCCC")),
    ProgressStatus.veryGood: Color(ColorFormatter.hexToInt("#549431")),
    ProgressStatus.good: Color(ColorFormatter.hexToInt("#549431")),
    ProgressStatus.impartial: Color(ColorFormatter.hexToInt("#076677")),
    ProgressStatus.bad: Color(ColorFormatter.hexToInt("#E41702")),
    ProgressStatus.veryBad: Color(ColorFormatter.hexToInt("#C21807")),
  };

  Color getColorForProgressStatus(ProgressStatus progress) {
    return _progressStatusColors[progress];
  }
}
