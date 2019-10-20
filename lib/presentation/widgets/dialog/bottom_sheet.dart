import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/fab.dart';

class InnaforBottomSheetController extends BaseController {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FabController fabController;
  final BuildContext context;
  bool showShadowOverlay = false;
  final bool withShadowOverlay;
  bool showComments;

  InnaforBottomSheetController(
      {this.scaffoldKey,
      this.fabController,
      this.context,
      this.withShadowOverlay,
      this.showComments});

  void showBottomSheet({@required var content}) {
    shadow(false);

    fabController?.showFabAsMethod(false);

    scaffoldKey.currentState
        .showBottomSheet((context) {
          return content;
        })
        .closed
        .then((v) {
          if (showShadowOverlay) {
            shadow(false);
          }
          if (fabController != null && showComments) {
            Timer(Duration(milliseconds: 170),
                () => fabController.showFabAsMethod(true));
          }
        });
  }

  void shadow(bool pop) {
    showShadowOverlay = !showShadowOverlay;
    if (pop) Navigator.pop(context);
    setState(() {});
  }
}

class InnaforBottomSheet extends BaseView {
  final InnaforBottomSheetController controller;

  InnaforBottomSheet({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return GestureDetector(
      onTap: () {
        controller.shadow(true);
      },
      child: controller.showShadowOverlay
          ? Container(
              height: 3000,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            )
          : Container(),
    );
  }
}
