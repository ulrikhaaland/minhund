import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/opening_hours.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOpeningHoursController extends DialogTemplateController {
  OpeningHours openingHours;

  OpeningHours placeholderOpeningHours;

  PageState pageState;

  final void Function(OpeningHours openingHours) onSaved;

  final _formKey = GlobalKey<FormState>();

  PartnerOpeningHoursController(
      {this.openingHours, this.pageState = PageState.read, this.onSaved});

  @override
  void initState() {
    placeholderOpeningHours = OpeningHours.fromJson(openingHours.toJson());
    super.initState();
  }

  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => pageState == PageState.edit
      ? SaveButton(
          controller: SaveButtonController(onPressed: () {
            _formKey.currentState.save();
            onSaved(placeholderOpeningHours);
            Navigator.pop(context);
          }),
        )
      : IconButton(
          onPressed: () => setState(() => pageState = PageState.edit),
          icon: Icon(Icons.edit),
          color:
              ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
          iconSize: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard,
        );

  @override
  String get title => "Åpningstider";

  String formatTime({int timeToFormat}) {
    String time = "n/a";

    if (timeToFormat != null) {
      time = timeToFormat.toString();
      if (time.length == 1) {
        time = "0" + time;
      }
    }

    return time;
  }

  @override
  // TODO: implement withBorder
  bool get withBorder => false;
}

class PartnerOpeningHours extends DialogTemplate {
  final PartnerOpeningHoursController controller;

  PartnerOpeningHours({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.pageState == PageState.edit) return buildEdit(context);

    if (controller.pageState == PageState.read) return buildRead(context);

    return Container();
  }

  Widget buildRead(BuildContext context) {
    double padding = getDefaultPadding(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.all(padding * 2),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ukedager: ",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.descTitle,
                  ),
                  Text(
                    "${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.dayFrom.hour)}:${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.dayFrom.minute)} - ${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.dayTo.hour)}:${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.dayTo.minute)}",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                  ),
                ],
              ),
              Container(
                height: padding * 2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Helg:",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.descTitle,
                  ),
                  Text(
                    "${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.weekendFrom.hour)}:${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.weekendFrom.minute)} - ${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.weekendTo.hour)}:${controller.formatTime(timeToFormat: controller.placeholderOpeningHours.weekendTo.minute)}",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                  ),
                ],
              ),
              Container(
                height: padding * 2,
              ),
              if (controller.placeholderOpeningHours.comment != null)
                Row(
                  children: <Widget>[
                    Text(
                      "Kommentar:",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.descTitle,
                    ),
                    Text(
                      controller.placeholderOpeningHours.comment,
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);

    return TapToUnfocus(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(padding * 2),
            child: Form(
              key: controller._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ukedager:",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.descTitle,
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          width: constraints.maxWidth / 2.25,
                          child: DateTimePicker(
                              controller: DateTimePickerController(
                                  asListTile: true,
                                  onConfirmed: (time) => controller
                                      .placeholderOpeningHours.dayFrom = time,
                                  label: "Fra",
                                  initialDate: controller
                                      .placeholderOpeningHours.dayFrom,
                                  time: true)),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: constraints.maxWidth / 2.25,
                          child: DateTimePicker(
                            controller: DateTimePickerController(
                                asListTile: true,
                                onConfirmed: (time) => controller
                                    .placeholderOpeningHours.dayTo = time,
                                label: "Til",
                                initialDate:
                                    controller.placeholderOpeningHours.dayTo,
                                time: true),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                    "Helg:",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.descTitle,
                  ),
                  Container(
                    height: padding * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          width: constraints.maxWidth / 2.25,
                          child: DateTimePicker(
                            controller: DateTimePickerController(
                                asListTile: true,
                                onConfirmed: (time) => controller
                                    .placeholderOpeningHours.weekendFrom = time,
                                label: "Fra",
                                initialDate: controller
                                    .placeholderOpeningHours.weekendFrom,
                                time: true),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: constraints.maxWidth / 2.25,
                          child: DateTimePicker(
                              controller: DateTimePickerController(
                                  asListTile: true,
                                  onConfirmed: (time) => controller
                                      .placeholderOpeningHours.weekendTo = time,
                                  label: "Til",
                                  initialDate: controller
                                      .placeholderOpeningHours.weekendTo,
                                  time: true)),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  PrimaryTextField(
                    asListTile: true,
                    initValue: controller.placeholderOpeningHours.comment,
                    hintText: "Kommentar",
                    onSaved: (val) => val == ""
                        ? controller.placeholderOpeningHours.comment = null
                        : controller.placeholderOpeningHours.comment = val,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    validate: false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
