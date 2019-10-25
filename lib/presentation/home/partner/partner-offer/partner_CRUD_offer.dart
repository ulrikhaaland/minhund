import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class PartnerCRUDOfferController extends MasterPageController {
  final PartnerOffer offer;

  PageState pageState;

  final _formKey = GlobalKey<FormState>();

  bool service = false;

  SaveButtonController saveButtonController;

  bool canSave = false;

  FocusScopeNode _scopeNode = FocusScopeNode();

  PartnerCRUDOfferController({this.offer, this.pageState});
  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => SaveButton(
        controller: saveButtonController,
      );

  @override
  Widget get bottomNav => null;

  @override
  Widget get fab => null;

  @override
  String get title =>
      pageState != PageState.create ? offer.title : "Nytt tilbud";

  @override
  void initState() {
    if (offer.title != "" && offer.title != null) {
      canSave = true;
    } else {
      canSave = false;
    }
    saveButtonController = SaveButtonController(
        canSave: canSave,
        onPressed: () {
          if (canSave) {
            _formKey.currentState.save();
          }
        });
    super.initState();
  }
}

class PartnerCRUDOffer extends MasterPage {
  final PartnerCRUDOfferController controller;

  PartnerCRUDOffer({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.pageState == PageState.edit ||
        controller.pageState == PageState.create) return _buildEdit(context);

    if (controller.pageState == PageState.read) return _buildRead(context);

    return Container();
  }

  Widget _buildRead(BuildContext context) {
    return Container();
  }

  Widget _buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);
    return TapToUnfocus(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 90),
      child: SingleChildScrollView(
        child: Form(
          child: FocusScope(
            node: controller._scopeNode,
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ServiceProvider
                        .instance.instanceStyleService.appStyle.borderRadius),
                  ),
                  child: Container(
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 80),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              "Vare",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.smallTitle,
                            ),
                            value: controller.service,
                            onChanged: (val) => controller.setState(
                                () => controller.service = !controller.service),
                            checkColor: Colors.white,
                            activeColor: ServiceProvider
                                .instance.instanceStyleService.appStyle.green,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              "Tjeneste",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.smallTitle,
                            ),
                            value: !controller.service,
                            onChanged: (val) => controller.setState(
                                () => controller.service = !controller.service),
                            checkColor: Colors.white,
                            activeColor: ServiceProvider
                                .instance.instanceStyleService.appStyle.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: padding * 2,
                ),
                PrimaryTextField(
                  paddingBottom: padding * 2,
                  asListTile: true,
                  textFieldType: TextFieldType.ordinary,
                  hintText: "Tittel",
                  initValue: controller.offer.title,
                  onFieldSubmitted: () => controller._scopeNode.nextFocus(),
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      controller.offer.title = val;
                      controller.canSave = true;
                    } else {
                      controller.canSave = false;
                    }
                    controller.saveButtonController.setState(() {
                      controller.saveButtonController.canSave =
                          controller.canSave;
                    });
                  },
                  validate: true,
                ),
                DateTimePicker(
                  controller: DateTimePickerController(
                    minDateTime: DateTime.now(),
                    dateFormat: "mm-HH-dd-MM-yyyy",
                    label: "Sluttdato for tilbudet",
                    onConfirmed: (date) {
                      controller.offer.endOfOffer = date;
                    },
                    initialDate: controller.offer.endOfOffer,
                  ),
                ),
                PrimaryTextField(
                  hintText: "Pris",
                  asListTile: true,
                  onSaved: (val) =>
                      controller.offer.price = int.parse(val).toDouble(),
                  textInputType: TextInputType.number,
                  initValue: controller.offer.price != null
                      ? controller.offer.price.toString()
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
