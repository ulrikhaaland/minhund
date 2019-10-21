import 'package:flutter/material.dart';
import 'package:minhund/bottom_navigation.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/model/partner/opening_hours.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/presentation/home/partner/partner_opening_hours.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_save_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerPageController extends BottomNavigationController {
  PageState pageState;

  final Partner partner;

  BoxConstraints constraints;

  CustomImage customImage;

  List<PrimaryTextField> editTextFields;

  final _formKey = GlobalKey<FormState>();

  ScrollController scrollController;

  FocusScopeNode focusScopeNode = FocusScopeNode();

  PartnerPageController({this.pageState = PageState.read, this.partner});

  @override
  // TODO: implement bottomNav
  Widget get bottomNav => null;

  @override
  // TODO: implement title
  String get title => partner.name;
  @override
  // TODO: implement actionTwo
  Widget get actionTwo => pageState == PageState.read
      ? IconButton(
          onPressed: () => setState(() => pageState = PageState.edit),
          icon: Icon(Icons.edit),
          color:
              ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
          iconSize: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard,
        )
      : DialogSaveButton(
          controller: DialogSaveButtonController(
            onPressed: () => setState(() => pageState = PageState.read),
          ),
        );

  @override
  initState() {
    if (partner.address == null) partner.address = Address();
    super.initState();
  }

  Widget readBasicContainer({
    String key,
    String value,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      height: constraints.minHeight * 0.1,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                key + ":",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.descTitle,
              ),
              Flexible(
                child: Text(
                  value ?? "",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.body1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget editBasicContainer({
    Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: getDefaultPadding(context) * 2),
      child: Container(
        alignment: Alignment.centerLeft,
        height: constraints.minHeight * 0.1,
        child: child,
      ),
    );
  }
}

class PartnerPage extends BottomNavigation {
  final PartnerPageController controller;

  PartnerPage({this.controller});

  void textFieldNext({double height}) {
    scrollScreen(
        controller: controller.scrollController,
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, height));
    controller.focusScopeNode.nextFocus();
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    controller.customImage = CustomImage(
      controller: CustomImageController(
        init: controller.pageState == PageState.edit ? true : false,
        imageSizePercentage: 10,
        imgUrl: controller.partner.imgUrl,
      ),
    );

    if (controller.pageState == PageState.read) return buildRead(context);

    if (controller.pageState == PageState.edit) return buildEdit(context);
  }

  Widget buildRead(BuildContext context) {
    double padding = getDefaultPadding(context);

    return LayoutBuilder(
      builder: (context, con) {
        controller.constraints = con;
        return Container(
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 80),
          child: Column(
            children: <Widget>[
              controller.customImage,
              Container(
                height: padding * 4,
              ),
              controller.readBasicContainer(
                  key: "Adresse", value: controller.partner.address?.address),
              controller.readBasicContainer(
                  key: "Postnummer", value: controller.partner.address?.zip),
              controller.readBasicContainer(
                key: "Poststed",
                value: controller.partner.address?.city,
              ),
              controller.readBasicContainer(
                key: "Email",
                value: controller.partner.email,
              ),
              controller.readBasicContainer(
                key: "Telefonnummer",
                value: controller.partner.phoneNumber,
              ),
              controller.readBasicContainer(
                key: "Kundenummer",
                value: controller.partner.id,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);

    controller.editTextFields = [
      PrimaryTextField(
        hintText: "Juridisk navn",
        initValue: controller.partner.name,
        onSaved: (val) => controller.partner.name,
        onFieldSubmitted: () => textFieldNext(height: 10),
      ),
      PrimaryTextField(
        hintText: "Adresse",
        initValue: controller.partner.address?.address,
        onSaved: (val) => controller.partner.address.address,
        onFieldSubmitted: () => textFieldNext(height: 0),
      ),
      PrimaryTextField(
        hintText: "Postkode",
        initValue: controller.partner.address?.zip,
        onSaved: (val) => controller.partner.address.zip,
        onFieldSubmitted: () => textFieldNext(height: 0),
      ),
      PrimaryTextField(
        hintText: "Poststed",
        initValue: controller.partner.address?.city,
        onFieldSubmitted: () => textFieldNext(height: 0),
        onSaved: (val) => controller.partner.address.city,
      ),
      PrimaryTextField(
        hintText: "Email",
        initValue: controller.partner.email,
        onFieldSubmitted: () => textFieldNext(height: 0),
        onSaved: (val) => controller.partner.email,
      ),
      PrimaryTextField(
          hintText: "Telefonnummer",
          initValue: controller.partner.phoneNumber,
          onSaved: (val) => controller.partner.phoneNumber),
    ];

    return LayoutBuilder(
      builder: (context, con) {
        return SingleChildScrollView(
          controller: controller.scrollController,
          child: Container(
            width: ServiceProvider.instance.screenService
                .getWidthByPercentage(context, 80),
            child: Column(
              children: <Widget>[
                controller.customImage,
                Container(
                  height: padding * 4,
                ),
                SecondaryButton(
                  color: Colors.white,
                  textColor: ServiceProvider
                      .instance.instanceStyleService.appStyle.textGrey,
                  text: "Åpningstider",
                  onPressed: () => showCustomDialog(
                    context: context,
                    child: PartnerOpeningHours(
                      controller: PartnerOpeningHoursController(
                          openingHours: controller.partner.openingHours ??
                              OpeningHours()),
                    ),
                  ),
                ),
                Container(
                  height: padding * 4,
                ),
                Form(
                  key: controller._formKey,
                  child: FocusScope(
                    node: controller.focusScopeNode,
                    child: Column(
                      children: controller.editTextFields
                          .map((tf) => controller.editBasicContainer(
                                child: tf,
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Container(
                  height: padding * 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
