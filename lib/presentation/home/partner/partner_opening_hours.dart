import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/opening_hours.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_save_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class PartnerOpeningHoursController extends DialogTemplateController {
  OpeningHours openingHours;

  PageState pageState;

  PartnerOpeningHoursController(
      {this.openingHours, this.pageState = PageState.read});
  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => pageState == PageState.edit
      ? DialogSaveButton(
          controller: DialogSaveButtonController(
              onPressed: () => Navigator.pop(context)),
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

  @override
  initState() {
    if (openingHours == null)
      openingHours = OpeningHours(
        dayFrom: DateTime.now(),
        dayTo: DateTime.now(),
        weekendFrom: DateTime.now(),
        weekendTo: DateTime.now(),
      );
    super.initState();
  }

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
                  )
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
                  )
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

    return LayoutBuilder(
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
                              label: "Til",
                              initialDate: controller.openingHours.weekendTo,
                              time: true)),
                    ),
                  )
                ],
              ),
              Divider(),
              PrimaryTextField(
                initValue: controller.openingHours.comment,
                hintText: "Kommentar",
                onSaved: (val) => controller.openingHours.comment = val,
                maxLines: 5,
              )
            ],
          ),
        );
      },
    );
  }
}
