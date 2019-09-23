import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/screen_service.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/set_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './app_bar_search_bar.dart';
import '../utilities/page_body_container.dart';

typedef OnBuild = Widget Function(BuildContext context);

class DetailTab {
  final IconData icon;
  final OnBuild buildFunction;
  final String text;

  DetailTab({
    @required this.icon,
    @required this.buildFunction,
    this.text,
    this.selected = false,
  });

  bool selected;
}

abstract class MasterPageController extends BaseController {
  BambooAppBarController _appBarController;

  BambooAppBarController get appBarController => _appBarController;

  final List<SetLoadingEvent> activeLoadingEvents = <SetLoadingEvent>[];
  bool get loading => activeLoadingEvents.length > 0;

  int get selectedBottomTab {
    if (bottomTabs == null) {
      return 0;
    }

    if (!bottomTabs.any((t) => t.selected ?? false)) {
      return 0;
    }

    return bottomTabs
        .indexOf(bottomTabs.firstWhere((t) => t.selected ?? false));
  }

  @override
  void initState() {
    super.initState();

    _appBarController = BambooAppBarController(
      searchBarManager: linkedSearchBarManager,
      title: title,
      actions: createAppBarActions(),
    );
  }

  List<Widget> createAppBarActions() {
    List<Widget> appBarActions = <Widget>[];

    if (actions != null) {
      actions.forEach((w) {
        Widget action = w;
        if (w is IconButton) {
          action = IconButton(
            onPressed: w.onPressed,
            color: w.color ??
                (w.icon as Icon).color ??
                ServiceProvider
                    .instance.instanceStyleService.appStyle.themeColor,
            iconSize: getAppBarIconSize(context),
            icon: w.icon,
          );
        }

        appBarActions.add(action);
      });
    }

    return appBarActions;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _tabChanged(List<DetailTab> tabs, int tabIndex) {
    tabs.forEach((t) => t.selected = (tabs[tabIndex] == t));

    tabChanged(tabIndex);
  }

  void tabChanged(int tabIndex) {
    refresh();
  }

  LinkedSearchBarManager get linkedSearchBarManager => null;

  /// If the page is initiated as part of a work flow such as
  /// drilling down from actor dashboard to product hierarchy drilldown
  bool get asWorkflow;

  /// The detail tabs that can be seen next to the
  /// content if the screen is big enough for it
  List<DetailTab> get detailTabs;

  /// The bottom tabs for the page
  List<DetailTab> get bottomTabs;

  /// The actions this page supplies
  /// These are rendered in the app bar
  List<Widget> get actions;

  /// If the page should contain a floating action button
  IconButton get floatingActionButton;

  /// The page title
  String get title;

  /// If the mini menu should be displayed
  bool get displayCollapsedMenu => true;

  void updateAppBar() {
    appBarController.forceUpdateWith(createAppBarActions(), title);
  }
}

abstract class MasterPage extends BaseView {
  final MasterPageController controller;

  MasterPage({this.controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container();
    }

    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

    final bool dialog =
        (parentRoute is PageRoute && parentRoute.fullscreenDialog) ||
            parentRoute is PopupRoute;

    /// Force the app bar to be "white" so that the time,
    /// battery and all those symbols are rendered as black
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    final ScreenSizeDefinition screenSizeDefinition =
        ServiceProvider.instance.screenService.getScreenSizeDefinition(context);
    final ScreenSizeDefinition horizontalScreenSizeDefinition = ServiceProvider
        .instance.screenService
        .getScreenWidthDefinition(context);
    final bool isLandscape =
        ServiceProvider.instance.screenService.isLandscape(context);

    Widget content;

    if (isLandscape) {
      content = buildContentLandscape(context, screenSizeDefinition);
    } else {
      content = buildContentPortrait(context, screenSizeDefinition);
    }

    Widget body = LayoutBuilder(
      builder: (con, constraints) {
        return PageContainer(
          displayBambooText: false,
          overrideBackgroundColor: Colors.transparent,
          loadMessage: controller.activeLoadingEvents.length > 0
              ? "LoadMessage()"
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              horizontalScreenSizeDefinition == ScreenSizeDefinition.small ||
                      dialog ||
                      !controller.displayCollapsedMenu
                  ? Container()
                  : Text("Previous menu"),
              horizontalScreenSizeDefinition == ScreenSizeDefinition.small ||
                      dialog
                  ? Container()
                  : Container(width: getDefaultPadding(context)),
              Expanded(
                child: Container(
                  height: constraints.maxHeight,
                  child: content,
                ),
              ),
              horizontalScreenSizeDefinition == ScreenSizeDefinition.big &&
                      isLandscape &&
                      controller.detailTabs != null &&
                      controller.detailTabs.length > 0
                  ? Container(
                      margin: EdgeInsets.only(left: getDefaultPadding(context)),
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 25.0),
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.pink,
                    )
                  : Container(),
            ],
          ),
        );
      },
    );

    return Scaffold(
      floatingActionButton: controller.floatingActionButton == null
          ? null
          : FloatingActionButton(
              child: controller.floatingActionButton,
              onPressed: () => null,
            ),
      bottomNavigationBar:
          controller.bottomTabs != null && controller.bottomTabs.length > 0
              ? BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: controller.bottomTabs
                      .map((t) => BottomNavigationBarItem(
                            icon: Icon(t.icon),
                            title: Text(t.text ?? ""),
                          ))
                      .toList(),
                  onTap: (index) =>
                      controller._tabChanged(controller.bottomTabs, index),
                  currentIndex:
                      controller.bottomTabs.any((t) => t.selected ?? false)
                          ? controller.bottomTabs.indexOf(controller.bottomTabs
                              .firstWhere((t) => t.selected ?? false))
                          : 0,
                )
              : null,
      body: Stack(
        children: <Widget>[
          //_Loader(controller: controller._loader),
          PageContainer(
            padding: EdgeInsets.only(
              top: 0.0,
              left: getDefaultPadding(context),
              right: getDefaultPadding(context),
              bottom: getDefaultPadding(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                dialog
                    ? Container(
                        height: getDefaultPadding(context),
                      )
                    : Container(),
                SafeArea(
                  bottom: false,
                  child: Container(
                    padding:
                        Theme.of(context).platform == TargetPlatform.android &&
                                !dialog
                            ? EdgeInsets.only(top: getDefaultPadding(context))
                            : null,
                    child: BambooAppBar(
                      controller: controller.appBarController,
                      // canGoBack: Navigator.canPop(context) && !(this is Home),
                      asWorkflow: controller.asWorkflow ?? false,
                      screenSize: screenSizeDefinition,
                    ),
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The build function for the main content when
  /// the width is greater than the height (landscape)
  Widget buildContentLandscape(
      BuildContext context, ScreenSizeDefinition screenSizeDefinition);

  /// The build function for the main content when
  /// the height is greater than the width (portrait)
  Widget buildContentPortrait(
      BuildContext context, ScreenSizeDefinition screenSizeDefinition);
}

class BambooAppBarController extends BaseController {
  final LinkedSearchBarManager searchBarManager;

  String title;

  List<Widget> actions;

  bool searchActivated = false;

  BambooAppBarController({
    this.searchBarManager,
    this.title,
    this.actions,
  });

  void forceUpdateWith(List<Widget> actions, String title) {
    setState(() {
      this.actions = actions;
      this.title = title;
    });
  }

  @override
  void didUpdateWidget(BaseView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class BambooAppBar extends BaseView {
  final BambooAppBarController controller;

  final bool asWorkflow;

  final bool canGoBack;

  final ScreenSizeDefinition screenSize;

  BambooAppBar({
    this.controller,
    this.asWorkflow,
    this.canGoBack,
    this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container();
    }

    return _buildContainer(
      context,
      _buildContent(context),
    );
  }

  Widget _buildContainer(BuildContext context, Widget content) {
    return Container(
      margin: EdgeInsets.only(bottom: getDefaultPadding(context)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 6.0) *
                  ServiceProvider.instance.screenService
                      .getBambooFactor(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: screenSize == ScreenSizeDefinition.veryBig
                    ? null
                    : BorderRadius.all(
                        Radius.circular(getDefaultPadding(context)),
                      ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    spreadRadius: getDefaultPadding(context) * 0.15,
                    blurRadius: getDefaultPadding(context) * 0.5,
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.pink,
                    offset: Offset(
                      getDefaultPadding(context) * 0.5,
                      getDefaultPadding(context) * 0.5,
                    ),
                  ),
                ],
              ),
              child: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

    final bool dialog =
        (parentRoute is PageRoute && parentRoute.fullscreenDialog) ||
            parentRoute is PopupRoute;

    final List<Widget> widgets = <Widget>[
      /// Do not display a menu icon if
      /// the page is part of a work flow
      asWorkflow || dialog
          ? Container()
          : IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              iconSize: getAppBarIconSize(context),
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.themeColor,
              icon: Icon(Icons.menu),
            ),
      (canGoBack ?? false) && !dialog
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: getAppBarIconSize(context),
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.themeColor,
              icon: Icon(Icons.arrow_back),
            )
          : Container(),
      dialog
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: getAppBarIconSize(context),
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.themeColor,
              icon: Icon(Icons.close),
            )
          : Container(),
      Expanded(
        child: GestureDetector(
          onTap: controller.searchBarManager != null
              ? () {
                  controller.setState(() => controller.searchActivated = true);
                }
              : null,
          child: Container(
            margin: EdgeInsets.only(
              left: getDefaultPadding(context),
              right: getDefaultPadding(context),
            ),
            child: Text(
              controller.title,
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.labelLight
                  .copyWith(
                fontSize: ServiceProvider
                        .instance.instanceStyleService.appStyle.label.fontSize *
                    1.2,
              ),
            ),
          ),
        ),
      ),
    ];

    if (controller.actions != null) {
      controller.actions.forEach((a) {
        widgets.add(a);
      });
    }

    return Row(
      children: widgets,
    );
  }
}
