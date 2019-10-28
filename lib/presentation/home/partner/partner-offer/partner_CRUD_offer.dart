import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/file_provider.dart';
import 'package:minhund/provider/partner_offer_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class PartnerCRUDOfferController extends MasterPageController {
  final PartnerOffer offer;

  PageState pageState;

  final String partnerId;

  final _formKey = GlobalKey<FormState>();

  bool service = false;

  final void Function(PartnerOffer offer) onCreate;

  SaveButtonController saveButtonController;

  bool canSave = false;

  FocusScopeNode _scopeNode = FocusScopeNode();

  FocusNode priceFocusNode = FocusNode();

  bool enabled = false;

  bool hasSaved;

  CustomImageController customImageController;

  PartnerCRUDOfferController(
      {this.offer, this.pageState, this.partnerId, this.onCreate});
  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => pageState != PageState.read
      ? SaveButton(
          controller: saveButtonController,
        )
      : IconButton(
          onPressed: () => setState(() {
            pageState = PageState.edit;
            customImageController.edit = true;
          }),
          icon: Icon(Icons.edit),
          color:
              ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
          iconSize: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard,
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

    customImageController = CustomImageController(
      edit: pageState != PageState.read,
      customImageType: CustomImageType.squared,
      imgUrl: offer.imgUrl,
      withLabel: true,
      onDelete: () {
        if (pageState == PageState.edit) {
          deleteImage();
        }
      },
      provideImageFile: (imgFile) => offer.imageFile = imgFile,
    );

    saveButtonController = SaveButtonController(
        canSave: canSave,
        onPressed: () async {
          if (canSave) {
            if (service) {
              offer.type = "service";
            } else if (!service) {
              offer.type = "product";
            }

            hasSaved = true;

            customImageController.edit = false;

            _formKey.currentState.save();

            if (pageState == PageState.create) {
              offer.createdAt = DateTime.now();
              offer.docRef = await PartnerOfferProvider()
                  .create(model: offer, id: "partners/$partnerId/offers");

              onCreate(offer);
            }

            if (offer.imageFile != null) {
              offer.imgUrl = await FileProvider().uploadFile(
                  file: offer.imageFile,
                  path: "partners/$partnerId/offers/${offer.id}/image");
            }

            PartnerOfferProvider().update(model: offer);

            if (pageState == PageState.edit) {
              setState(() => pageState = PageState.read);
            }

            if (pageState == PageState.create) Navigator.pop(context);
          }
        });
    super.initState();
  }

  void deleteImage() {
    offer.imageFile = null;

    FileProvider()
        .deleteFile(path: "partners/$partnerId/offers/${offer.id}/image");

    offer.imgUrl = null;
  }

  @override
  void dispose() {
    if (hasSaved != true) offer.imageFile = null;
    _scopeNode.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }
}

class PartnerCRUDOffer extends MasterPage {
  final PartnerCRUDOfferController controller;

  PartnerCRUDOffer({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    controller.enabled = controller.pageState == PageState.edit ||
        controller.pageState == PageState.create;

    return _buildEdit(context);
  }

  Widget _buildRead(BuildContext context) {
    return Container();
  }

  Widget _buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);

    return TapToUnfocus(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 90),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Form(
            key: controller._formKey,
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
                              value: !controller.service,
                              onChanged: (val) => controller.enabled
                                  ? controller.setState(() =>
                                      controller.service = !controller.service)
                                  : null,
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
                              value: controller.service,
                              onChanged: (val) => controller.enabled
                                  ? controller.setState(() =>
                                      controller.service = !controller.service)
                                  : null,
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
                    enabled: controller.enabled,
                    asListTile: true,
                    textFieldType: TextFieldType.ordinary,
                    hintText: "Tittel",
                    textCapitalization: TextCapitalization.sentences,
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
                      enabled: controller.enabled,
                      minDateTime: DateTime.now(),
                      validate: false,
                      label: "Sluttdato for tilbudet",
                      onConfirmed: (date) {
                        controller.offer.endOfOffer = date;
                        controller.priceFocusNode.requestFocus();
                      },
                      initialDate: controller.offer.endOfOffer,
                    ),
                  ),
                  PrimaryTextField(
                    hintText: "Pris",
                    focusNode: controller.priceFocusNode,
                    enabled: controller.enabled,
                    asListTile: true,
                    validate: false,
                    prefixText: "NOK ",
                    onSaved: (val) => controller.offer.price =
                        val.isEmpty ? null : double.parse(val),
                    textInputType: TextInputType.number,
                    onFieldSubmitted: () => controller._scopeNode.nextFocus(),
                    initValue: controller.offer.price != null
                        ? controller.offer.price.toString()
                        : null,
                  ),
                  PrimaryTextField(
                    hintText: "Beskrivelse",
                    enabled: controller.enabled,
                    asListTile: true,
                    validate: false,
                    onSaved: (val) => controller.offer.desc = val,
                    textInputType: TextInputType.number,
                    initValue: controller.offer.desc,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 5,
                  ),
                  if ((controller.offer.imgUrl != null ||
                              controller.offer.imageFile != null) &&
                          controller.pageState == PageState.read ||
                      controller.pageState != PageState.read)
                    Container(
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 80),
                      alignment: Alignment.centerLeft,
                      child: CustomImage(
                        controller: controller.customImageController,
                      ),
                    ),
                  Container(
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: padding * 2,
                              bottom: padding,
                              top: padding * 4),
                          child: Text(
                            "Hvis tilbudet skal være synlig for kunder må det være aktivt, dette kan du endre senere.",
                            style: ServiceProvider
                                .instance.instanceStyleService.appStyle.body1,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ServiceProvider
                                .instance
                                .instanceStyleService
                                .appStyle
                                .borderRadius),
                          ),
                          elevation: 1,
                          child: CheckboxListTile(
                            dense: true,
                            value: controller.offer.active ?? false,
                            onChanged: (val) => controller.enabled
                                ? controller.setState(
                                    () => controller.offer.active = val)
                                : null,
                            checkColor: Colors.white,
                            activeColor: ServiceProvider
                                .instance.instanceStyleService.appStyle.green,
                            title: Text(
                              "Aktivt",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.descTitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: padding * 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
