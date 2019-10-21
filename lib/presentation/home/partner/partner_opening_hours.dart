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
  final OpeningHours openingHours;

  PageState pageState;

  PartnerOpeningHoursController({this.openingHours, this.pageState});
  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => DialogSaveButton(
        controller:
            DialogSaveButtonController(onPressed: () => Navigator.pop(context)),
      );

  @override
  String get title => "Åpningstider";
}

class PartnerOpeningHours extends DialogTemplate {
  final PartnerOpeningHoursController controller;

  PartnerOpeningHours({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

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
