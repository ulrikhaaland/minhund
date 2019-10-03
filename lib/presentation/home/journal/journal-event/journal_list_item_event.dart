import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/service/service_provider.dart';

class JournalListItemEventController extends BaseController {
  final JournalEventItem eventItem;

  final String title;

  JournalListItemEventController({this.eventItem, this.title});
}

class JournalListItemEvent extends BaseView {
  final JournalListItemEventController controller;

  JournalListItemEvent({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Container(
      padding: EdgeInsets.all(getDefaultPadding(context) * 2),
      // color: ServiceProvider.instance.instanceStyleService.appStyle.lightBlue,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  controller.title + " - Ny oppgave",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.smallTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.textGrey,
                  size: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeStandard,
                ),
              ),
            ],
          ),
          Container(
            height: getDefaultPadding(context) * 2,
          ),
          LayoutBuilder(
            builder: (context, con) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DateTimePicker(
                  controller: DateTimePickerController(
                      width: con.maxWidth / 2.2,
                      overrideInitialDate: true,
                      onConfirmed: (date) {
                        controller.eventItem.timeStamp = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          controller.eventItem.timeStamp?.hour ??
                              DateTime.now().hour,
                          controller.eventItem.timeStamp?.hour ??
                              DateTime.now().minute,
                        );
                        print(controller.eventItem.timeStamp.toString());
                      },
                      // initialDate: DateTime.now(),
                      title: "Dato",
                      label: "Dato"),
                ),
                DateTimePicker(
                  controller: DateTimePickerController(
                      time: true,
                      dateFormat: "HH-mm",
                      width: con.maxWidth / 2.2,
                      overrideInitialDate: true,
                      onConfirmed: (date) {
                        controller.eventItem.timeStamp = DateTime(
                            controller.eventItem.timeStamp?.year ??
                                DateTime.now().year,
                            controller.eventItem.timeStamp?.month ??
                                DateTime.now().month,
                            controller.eventItem.timeStamp?.day ??
                                DateTime.now().day,
                            date.hour,
                            date.minute);
                        print(controller.eventItem.timeStamp.toString());
                      },
                      // initialDate: DateTime.now(),
                      title: "Tidspunkt",
                      label: "Tidspunkt"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
