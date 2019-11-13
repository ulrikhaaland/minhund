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

  PageState pageState;

  final _formKey = GlobalKey<FormState>();

  PartnerOpeningHoursController(
      {this.openingHours, this.pageState = PageState.read});
  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => pageState == PageState.edit
      ? SaveButton(
          controller: SaveButtonController(onPressed: () {
            _formKey.currentState.save();
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
                    "${controller.formatTime(timeToFormat: controller.openingHours.dayFrom.hour)}:${controller.formatTime(timeToFormat: controller.openingHours.dayFrom.minute)} - ${controller.formatTime(timeToFormat: controller.openingHours.dayTo.hour)}:${controller.formatTime(timeToFormat: controller.openingHours.dayTo.minute)}",
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
                    "${controller.formatTime(timeToFormat: controller.openingHours.weekendFrom.hour)}:${controller.formatTime(timeToFormat: controller.openingHours.weekendFrom.minute)} - ${controller.formatTime(timeToFormat: controller.openingHours.weekendTo.hour)}:${controller.formatTime(timeToFormat: controller.openingHours.weekendTo.minute)}",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                  ),
                ],
              ),
              Container(
                height: padding * 2,
              ),
              if (controller.openingHours.comment != null)
                Row(
                  children: <Widget>[
                    Text(
                      "Kommentar:",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.descTitle,
                    ),
                    Text(
                      controller.openingHours.comment,
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

                                onConfirmed: (time) =>
                                    controller.openingHours.dayFrom = time,
                                label: "Fra",
                                initialDate: controller.openingHours.dayFrom,
                                time: true)),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: constraints.maxWidth / 2.25,
                        child: DateTimePicker(
                          controller: DateTimePickerController(
                              asListTile: true,

                              onConfirmed: (time) =>
                                  controller.openingHours.dayTo = time,
                              label: "Til",
                              initialDate: controller.openingHours.dayTo,
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

                              onConfirmed: (time) =>
                                  controller.openingHours.weekendFrom = time,
                              label: "Fra",
                              initialDate: controller.openingHours.weekendFrom,
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
                                onConfirmed: (time) =>
                                    controller.openingHours.weekendTo = time,
                                label: "Til",
                                initialDate: controller.openingHours.weekendTo,
                                time: true)),
                      ),
                    )
                  ],
                ),
                Divider(),
                Form(
                  key: controller._formKey,
                  child: PrimaryTextField(
                    asListTile: true,
                    initValue: controller.openingHours.comment,
                    hintText: "Kommentar",
                    onSaved: (val) => val == ""
                        ? controller.openingHours.comment = null
                        : controller.openingHours.comment = val,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    validate: false,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
