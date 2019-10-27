import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class PartnerOfferListItemController extends BaseController {
  final PartnerOffer offer;

  PartnerOfferListItemController({this.offer});
}

class PartnerOfferListItem extends BaseView {
  final PartnerOfferListItemController controller;

  final Key key;

  PartnerOfferListItem({this.controller, this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return null;
  }
}
