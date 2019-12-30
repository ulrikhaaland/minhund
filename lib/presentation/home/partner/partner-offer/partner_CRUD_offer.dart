import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_offer_reserve.dart';
import 'package:minhund/presentation/home/partner/partner-offer/partner_offers_page.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/file_provider.dart';
import 'package:minhund/provider/partner/partner_offer_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';

class PartnerCRUDOfferController extends MasterPageController
    implements OfferActionController {
  PartnerOffer offer;

  PartnerOffer placeholderOffer;

  PageState pageState;

  final String partnerId;

  final _formKey = GlobalKey<FormState>();

  final PartnerOffersPageController actionController;

  SaveButtonController saveButtonController;

  bool canSave = false;

  FocusScopeNode _scopeNode = FocusScopeNode();

  FocusNode priceFocusNode = FocusNode();

  bool enabled;

  DateTimePickerController dateTimePickerController;

  bool hasSaved;

  CustomImageController customImageController;

  PartnerOfferReserveController offerReserveController;

  PartnerCRUDOfferController({
    this.actionController,
    this.offer,
    this.pageState,
    this.partnerId,
  });

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => [
        if (pageState == PageState.edit)
          IconButton(
            onPressed: () => setState(() {
              showCustomDialog(
                context: context,
                dialogSize: DialogSize.medium,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      getDefaultPadding(context) * 2,
                      getDefaultPadding(context) * 4,
                      getDefaultPadding(context) * 2,
                      getDefaultPadding(context) * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Slettingen kan ikke reverseres. Er du sikker på at du vil slette tilbudet?",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1,
                      ),
                      SecondaryButton(
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.pink,
                        text: "Slett",
                        onPressed: () {
                          onOfferDelete(offer: this.offer);
                        },
                      )
                    ],
                  ),
                ),
              );
            }),
            icon: Icon(
              Icons.delete,
            ),
            color:
                ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
            iconSize: ServiceProvider
                .instance.instanceStyleService.appStyle.iconSizeStandard,
          ),
        pageState != PageState.read
            ? SaveButton(
                controller: saveButtonController,
              )
            : IconButton(
                onPressed: () => setState(() {
                  pageState = PageState.edit;

                  offerReserveController.enabled = true;

                  dateTimePickerController.enabled = true;

                  customImageController.edit = true;
                }),
                icon: Icon(Icons.edit),
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.textGrey,
                iconSize: ServiceProvider
                    .instance.instanceStyleService.appStyle.iconSizeStandard,
              ),
      ];

  @override
  Widget get bottomNav => null;

  @override
  Widget get fab => null;

  @override
  String get title => pageState != PageState.create
      ? pageState == PageState.read ? placeholderOffer.title : "Rediger"
      : "Nytt tilbud";

  @override
  void initState() {
    placeholderOffer = PartnerOffer.fromJson(offer.toJson());
    if (offer.docRef != null) placeholderOffer.docRef = offer.docRef;

    if (placeholderOffer.title != "" && placeholderOffer.title != null) {
      canSave = true;
    } else {
      canSave = false;
    }

    enabled = pageState != PageState.read;

    placeholderOffer.type == null
        ? placeholderOffer.type = OfferType.item
        : null;

    dateTimePickerController = DateTimePickerController(
      enabled: enabled,
      minDateTime: DateTime.now(),
      validate: false,
      asListTile: true,
      label: "Sluttdato for tilbudet",
      onConfirmed: (date) {
        placeholderOffer.endOfOffer = date;
        priceFocusNode.requestFocus();
      },
      initialDate: placeholderOffer.endOfOffer,
    );

    customImageController = CustomImageController(
      edit: pageState != PageState.read,
      customImageType: CustomImageType.squared,
      imageSizePercentage: 80,
      imgUrl: placeholderOffer.imgUrl,
      withLabel: true,
      onDelete: () {
        if (pageState == PageState.edit) {
          deleteImage();
        }
      },
      provideImageFile: (imgFile) => placeholderOffer.imageFile = imgFile,
    );

    saveButtonController = SaveButtonController(
        canSave: canSave,
        onPressed: () {
          createOrUpdateOffer();
        });

    offerReserveController = PartnerOfferReserveController(
      offerId: placeholderOffer.id,
      offer: placeholderOffer,
      enabled: enabled,
      pageState: pageState,
      checkIfOnline: () => placeholderOffer.type == OfferType.online,
      reservation: placeholderOffer.partnerReservation,
    );
    super.initState();
  }

  void deleteImage() {
    placeholderOffer.imageFile = null;

    FileProvider()
        .deleteFile(path: "partnerOffers/${placeholderOffer.id}/image");

    placeholderOffer.imgUrl = null;

    PartnerOfferProvider().update(model: placeholderOffer);
  }

  @override
  void dispose() {
    if (hasSaved != true) placeholderOffer.imageFile = null;
    _scopeNode.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }

  Future<void> createOrUpdateOffer() async {
    if (canSave) {
      saveButtonController.load();

      offer = placeholderOffer;

      dateTimePickerController.enabled = false;

      offerReserveController.enabled = false;

      hasSaved = true;

      customImageController.edit = false;

      _formKey.currentState.save();

      if (pageState == PageState.create) {
        await onOfferCreate(offer: this.offer);
      }

      if (offer.imageFile != null) {
        offer.imgUrl = await FileProvider().uploadFile(
            file: offer.imageFile, path: "partnerOffers/${offer.id}/image");

        customImageController.imgUrl = offer.imgUrl;
      }

      onOfferUpdate(offer: this.offer);
      saveButtonController.load();

      // isLoading = false;
    }
  }

  @override
  Future<void> onOfferCreate({PartnerOffer offer}) async {
    return await actionController.onOfferCreate(offer: offer).then((_) async {
      offer.createdAt = DateTime.now();
      offer.docRef = await PartnerOfferProvider()
          .create(model: offer, id: "partnerOffers");
    });
  }

  @override
  Future<void> onOfferDelete({PartnerOffer offer}) {
    return actionController.onOfferDelete(offer: offer).then((_) {
      if (placeholderOffer.imgUrl != null)
        FileProvider()
            .deleteFile(path: "partnerOffers/${placeholderOffer.id}/image");

      Navigator.of(context)..pop()..pop();
    });
  }

  @override
  Future<void> onOfferUpdate({PartnerOffer offer}) {
    return actionController.onOfferUpdate(offer: this.offer).then((_) {
      if (pageState == PageState.edit) {
        setState(() => pageState = PageState.read);
      }

      if (pageState == PageState.create) Navigator.pop(context);
    });
  }

  @override
  bool get enabledTopSafeArea => null;

  @override
  bool get hasBottomNav => false;
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

  Widget _buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);

    return TapToUnfocus(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 90),
      child: Stack(
        children: <Widget>[
          Scrollbar(
            child: SingleChildScrollView(
              child: Form(
                key: controller._formKey,
                child: FocusScope(
                  node: controller._scopeNode,
                  child: Column(
                    children: <Widget>[
                      PartnerOfferReserve(
                        controller: controller.offerReserveController,
                      ),
                      Container(
                        height: padding * 2,
                      ),
                      Card(
                        elevation: controller.enabled ? 3 : 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ServiceProvider
                              .instance
                              .instanceStyleService
                              .appStyle
                              .borderRadius),
                        ),
                        child: Container(
                          width: ServiceProvider.instance.screenService
                              .getWidthByPercentage(context, 80),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CheckboxListTile(
                                title: Text(
                                  "Vare",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.smallTitle,
                                ),
                                value: controller.placeholderOffer.type ==
                                    OfferType.item,
                                onChanged: (val) => controller.enabled
                                    ? controller.setState(() => val
                                        ? controller.placeholderOffer.type =
                                            OfferType.item
                                        : null)
                                    : null,
                                checkColor: Colors.white,
                                activeColor: ServiceProvider.instance
                                    .instanceStyleService.appStyle.green,
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "Tjeneste",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.smallTitle,
                                ),
                                value: controller.placeholderOffer.type ==
                                    OfferType.service,
                                onChanged: (val) => controller.enabled
                                    ? controller.setState(() => val
                                        ? controller.placeholderOffer.type =
                                            OfferType.service
                                        : null)
                                    : null,
                                checkColor: Colors.white,
                                activeColor: ServiceProvider.instance
                                    .instanceStyleService.appStyle.green,
                              ),
                              AnimatedContainer(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .borderRadius),
                                      bottomRight: Radius.circular(
                                          ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .borderRadius)),
                                  //  BorderRadius.circular(
                                  //     ServiceProvider.instance.instanceStyleService
                                  //         .appStyle.borderRadius),
                                  color: controller.placeholderOffer.type ==
                                          OfferType.online
                                      ? ServiceProvider
                                          .instance
                                          .instanceStyleService
                                          .appStyle
                                          .lightBlue
                                      : Colors.white,
                                ),
                                duration: Duration(milliseconds: 500),
                                width: ServiceProvider.instance.screenService
                                    .getWidthByPercentage(context, 80),
                                child: Column(
                                  children: <Widget>[
                                    CheckboxListTile(
                                      title: Text(
                                        "På nett",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .smallTitle,
                                      ),
                                      value: controller.placeholderOffer.type ==
                                          OfferType.online,
                                      onChanged: (val) {
                                        if (controller
                                                .placeholderOffer
                                                .partnerReservation
                                                .canReserve !=
                                            true) {
                                          controller.enabled
                                              ? controller.setState(() => val
                                                  ? controller.placeholderOffer
                                                      .type = OfferType.online
                                                  : null)
                                              : null;
                                        } else if (controller.enabled) {
                                          showCustomDialog(
                                            context: context,
                                            dialogSize: DialogSize.small,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(padding * 2),
                                              child: Text(
                                                  'Tilbudstype "På nett" og reservasjon kan ikke kombineres. '),
                                            ),
                                          );
                                        }
                                      },
                                      checkColor: Colors.white,
                                      activeColor: ServiceProvider.instance
                                          .instanceStyleService.appStyle.green,
                                    ),
                                    if (controller.placeholderOffer.type ==
                                        OfferType.online) ...[
                                      PrimaryTextField(
                                        width: ServiceProvider
                                            .instance.screenService
                                            .getWidthByPercentage(context, 74),
                                        hintText: "Rabattkode",
                                        enabled: controller.enabled,
                                        asListTile: true,
                                        validate: false,
                                        onSaved: (val) => controller
                                            .placeholderOffer
                                            .discountCode = val,
                                        textInputType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        onFieldSubmitted: () =>
                                            controller._scopeNode.nextFocus(),
                                        initValue: controller.placeholderOffer
                                                    .discountCode !=
                                                null
                                            ? controller
                                                .placeholderOffer.discountCode
                                                .toString()
                                            : null,
                                      ),
                                      PrimaryTextField(
                                        width: ServiceProvider
                                            .instance.screenService
                                            .getWidthByPercentage(context, 74),
                                        hintText: "Weblink til tilbudet",
                                        enabled: controller.enabled,
                                        asListTile: true,
                                        validate: false,
                                        prefixText: "www.",
                                        onSaved: (val) => controller
                                            .placeholderOffer.url = val,
                                        textInputType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        initValue: controller
                                                    .placeholderOffer.url !=
                                                null
                                            ? controller.placeholderOffer.url
                                                .toString()
                                            : null,
                                      )
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: padding * 4,
                      ),
                      PrimaryTextField(
                        paddingBottom: padding * 2,
                        enabled: controller.enabled,
                        asListTile: true,
                        textFieldType: TextFieldType.ordinary,
                        hintText: "Tittel",
                        textCapitalization: TextCapitalization.sentences,
                        initValue: controller.placeholderOffer.title,
                        onFieldSubmitted: () =>
                            controller._scopeNode.nextFocus(),
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            controller.placeholderOffer.title = val;
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
                        controller: controller.dateTimePickerController,
                      ),
                      PrimaryTextField(
                        hintText: "Pris",
                        focusNode: controller.priceFocusNode,
                        enabled: controller.enabled,
                        asListTile: true,
                        validate: false,
                        prefixText: "NOK ",
                        onSaved: (val) => controller.placeholderOffer.price =
                            val.isEmpty ? null : double.parse(val),
                        textInputType: TextInputType.number,
                        onFieldSubmitted: () =>
                            controller._scopeNode.nextFocus(),
                        initValue: controller.placeholderOffer.price != null
                            ? controller.placeholderOffer.price.toString()
                            : null,
                      ),
                      PrimaryTextField(
                        hintText: "Beskrivelse",
                        enabled: controller.enabled,
                        asListTile: true,
                        validate: false,
                        onSaved: (val) =>
                            controller.placeholderOffer.desc = val,
                        textInputType: TextInputType.text,
                        initValue: controller.placeholderOffer.desc,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                      ),
                      if ((controller.placeholderOffer.imgUrl != null ||
                                  controller.placeholderOffer.imageFile !=
                                      null) &&
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
                                "Hvis tilbudet skal være synlig for kunder må det være aktivt. Dette kan du endre når som helst.",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .borderRadius),
                              ),
                              elevation: controller.enabled ? 1 : 0,
                              child: CheckboxListTile(
                                dense: true,
                                value:
                                    controller.placeholderOffer.active ?? false,
                                onChanged: (val) => controller.enabled
                                    ? controller.setState(() => controller
                                        .placeholderOffer.active = val)
                                    : null,
                                checkColor: Colors.white,
                                activeColor: ServiceProvider.instance
                                    .instanceStyleService.appStyle.green,
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
        ],
      ),
    );
  }
}
