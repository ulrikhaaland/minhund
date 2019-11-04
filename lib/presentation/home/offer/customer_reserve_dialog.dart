import 'package:flutter/material.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';

class CustomerReserveDialogController extends DialogTemplateController {
  final String userId;

  CustomerReserveDialogController({this.userId});
  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => null;

  @override
  // TODO: implement title
  String get title => "Reserver";
}

class CustomerReserveDialog extends DialogTemplate {
  final CustomerReserveDialogController controller;

  CustomerReserveDialog({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();
    return Container();
  }
}
