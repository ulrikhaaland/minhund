import 'package:flutter/material.dart';
import 'package:minhund/utilities/master_page.dart';

class CustomerOfferPageController extends MasterPageController {
  @override
  // TODO: implement actionOne
  Widget get actionOne => null;

  @override
  // TODO: implement actionTwoList
  List<Widget> get actionTwoList => null;

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement fab
  Widget get fab => null;

  @override
  // TODO: implement title
  String get title => null;
}

class CustomerOfferPage extends MasterPage {
  final CustomerOfferPageController controller;

  CustomerOfferPage({this.controller});
  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();
    // TODO: implement buildContent
    return Container();
  }
}
