import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/fcm/reminder.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_page.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/fcm_provider.dart';
import 'package:minhund/service/service_provider.dart';

class JournalEventDialogController extends DialogTemplateController
    implements EventActionController {
  JournalEventItem eventItem;

  JournalEventItem placeHolderEventItem;

  final JournalEventPageController actionController;

  final DocumentReference parentDocRef;

  String reminderDropDownValue;

  double height;

  bool reminderError = false;

  String reminderErrorText = "";

  FocusScopeNode scopeNode = FocusScopeNode();

  final _formKey = GlobalKey<FormState>();

  bool firstBuild = true;

  bool hasFocus = true;

  final bool canEdit;

  PageState pageState;

  final User user;

  Widget popIcon;

  bool canSave = false;

  DateTimePickerController datePickerController;

  DateTimePickerController timePickerController;

  SaveButtonController saveBtnCtrlr;

  List<String> reminderItems = [
    "Ingen",
    '1 dag før',
    '2 dager før',
    '1 uke før',
  ];

  JournalEventDialogController({
    this.eventItem,
    this.actionController,
    this.user,
    this.canEdit,
    this.parentDocRef,
    this.pageState,
  });

  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => canEdit == false
      ? null
      : pageState != PageState.read
          ? SaveButton(
              controller: saveBtnCtrlr,
            )
          : IconButton(
              onPressed: () => setState(() => pageState = PageState.edit),
              icon: Icon(Icons.edit),
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.textGrey,
              iconSize: ServiceProvider
                  .instance.instanceStyleService.appStyle.iconSizeStandard,
            );

  @override
  String get title {
    switch (pageState) {
      case PageState.create:
        return "Ny oppgave";
        break;
      case PageState.edit:
        return "Rediger oppgave";

        break;
      case PageState.read:
        return placeHolderEventItem.title ?? "N/A";

        break;
      default:
        return "Ny oppgave";
    }
  }

  @override
  initState() {
    if (eventItem == null) {
      placeHolderEventItem = JournalEventItem(title: "", completed: false);

      reminderDropDownValue = "Ingen";
    } else {
      firstBuild = false;
      placeHolderEventItem = JournalEventItem(
          id: eventItem.id,
          docRef: eventItem.docRef,
          title: eventItem.title,
          timeStamp: eventItem.timeStamp,
          note: eventItem.note,
          reminder: eventItem.reminder,
          reminderString: eventItem.reminderString,
          completed: eventItem.completed);
      reminderDropDownValue = placeHolderEventItem.reminderString ?? "Ingen";
    }

    if (placeHolderEventItem.title.length > 0) {
      canSave = true;
    }

    saveBtnCtrlr = SaveButtonController(
        canSave: canSave, onPressed: () => saveEventItem());

    super.initState();
  }

  @override
  void dispose() {
    scopeNode.dispose();
    super.dispose();
  }

  void saveEventItem() {
    if (canSave) {
      Reminder reminder;

      if (placeHolderEventItem.reminder != null) {
        reminder = Reminder(
            title: "Påminnelse",
            body:
                "${placeHolderEventItem.title} starter om ${placeHolderEventItem.reminderString.split("f")[0]}",
            note: placeHolderEventItem.note,
            userId: user.id,
            timestamp:
                placeHolderEventItem.reminder.subtract(Duration(hours: 2)));

        reminder.timestampAsIso =
            reminder.timestamp.toIso8601String().split("T")[0];
      }
      if (eventItem == null) {
        onEventCreate(event: placeHolderEventItem).then((item) {
          if (reminder != null) {
            reminder.eventId = item.documentID;
            FCMProvider()
                .set(id: "reminders/${reminder.eventId}", model: reminder);
          }
        });
      } else {
        onEventUpdate(event: placeHolderEventItem).then((_) {
          if (reminder != null) {
            reminder.eventId = placeHolderEventItem.id;
            Firestore.instance
                .document("reminders/${reminder.eventId}")
                .setData(reminder.toJson());
          }
        });
      }
      Navigator.pop(context);
    }
  }

  @override
  bool get withBorder => false;

  @override
  Future<DocumentReference> onEventCreate({JournalEventItem event}) {
    return actionController.onEventCreate(event: event);
  }

  @override
  Future<void> onEventDelete({JournalEventItem event}) {
    return actionController.onEventDelete(event: event);
  }

  @override
  Future<void> onEventUpdate({JournalEventItem event}) {
    return actionController.onEventUpdate(event: event);
  }
}

class JournalEventDialog extends DialogTemplate {
  final JournalEventDialogController controller;

  double maxWidth;
  double maxHeight;

  JournalEventDialog({this.controller});

  Widget basicContainer({
    Widget child,
    double width,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      height: maxHeight * 0.1,
      width: width != null ? (width * 0.935) / 2 : null,
      child: child,
    );
  }

  Widget basicContainer2({
    Widget child,
    double width,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      height: maxHeight * 0.05,
      width: width != null ? (width * 0.935) / 2 : null,
      child: child,
    );
  }

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

    maxWidth = ServiceProvider.instance.screenService
        .getWidthByPercentage(context, 80);

    maxHeight = ServiceProvider.instance.screenService
        .getHeightByPercentage(context, 80);

    controller.popIcon = InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.close,
            color:
                ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
            size: ServiceProvider
                .instance.instanceStyleService.appStyle.iconSizeStandard,
          ),
        ),
      ),
    );

    if (controller.pageState != PageState.read) return buildEdit(context);
    return buildRead(context);
  }

  void _setDatePickers() {
    controller.datePickerController = DateTimePickerController(
        asListTile: true,
        validate: false,
        // width: ServiceProvider.instance.screenService
        //         .getWidthByPercentage(context, 80) /
        //     2.1,
        overrideInitialDate:
            controller.placeHolderEventItem.timeStamp == null ? true : false,
        onConfirmed: (date) {
          controller.placeHolderEventItem.timeStamp = DateTime(
              date.year,
              date.month,
              date.day,
              controller.placeHolderEventItem.timeStamp?.hour ?? 11,
              controller.placeHolderEventItem.timeStamp?.minute ?? 11,
              11);

          // if (controller.placeHolderEventItem.timeStamp.second ==
          //     11)
          //   Timer(
          //       Duration(milliseconds: 50),
          //       () => controller.timePickerController
          //           .openDatePicker(context));
        },
        initialDate:
            controller.placeHolderEventItem.timeStamp ?? DateTime.now(),
        title: "Dato",
        label: "Dato");

    controller.timePickerController = DateTimePickerController(
        asListTile: true,
        validate: false,
        time: true,
        dateFormat: "HH-mm",
        width: ServiceProvider.instance.screenService
                .getWidthByPercentage(context, 80) /
            2.1,
        overrideInitialDate:
            controller.placeHolderEventItem.timeStamp == null ? true : false,
        onConfirmed: (date) {
          controller.placeHolderEventItem.timeStamp = DateTime(
              controller.placeHolderEventItem.timeStamp?.year ??
                  DateTime.now().year,
              controller.placeHolderEventItem.timeStamp?.month ??
                  DateTime.now().month,
              controller.placeHolderEventItem.timeStamp?.day ??
                  DateTime.now().day,
              date.hour,
              date.minute,
              0);
          print(controller.placeHolderEventItem.timeStamp.toString());
        },
        initialDate:
            controller.placeHolderEventItem.timeStamp ?? DateTime.now(),
        title: "Tidspunkt",
        label: "Tidspunkt");
  }

  Widget buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);

    controller.hasFocus = controller.scopeNode.hasFocus;

    _setDatePickers();

    return TapToUnfocus(
      child: Scrollbar(
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(padding * 2),
          child: FocusScope(
            node: controller.scopeNode,
            child: Form(
              key: controller._formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      // height: controller.pageState == PageState.edit
                      //     ? maxHeight * 0.8
                      //     : maxHeight,
                      child: ListView(
                        // shrinkWrap: true,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PrimaryTextField(
                            asListTile: true,
                            initValue: controller.placeHolderEventItem.title,
                            textCapitalization: TextCapitalization.sentences,
                            textInputType: TextInputType.text,
                            autoFocus:
                                controller.placeHolderEventItem.title == ""
                                    ? controller.firstBuild
                                    : false,
                            textFieldType: TextFieldType.ordinary,
                            hintText: "Tittel",
                            onChanged: (val) {
                              if (val.isNotEmpty)
                                controller.canSave = true;
                              else
                                controller.canSave = false;
                              controller.placeHolderEventItem.title = val;
                              controller.setState(() {
                                controller.saveBtnCtrlr.canSave =
                                    controller.canSave;
                              });
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: () {
                              controller.hasFocus = false;
                              controller.datePickerController
                                  .openDatePicker(context);
                            },
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: DateTimePicker(
                                  controller: controller.datePickerController,
                                ),
                              ),
                              Expanded(
                                child: DateTimePicker(
                                    controller:
                                        controller.timePickerController),
                              ),
                            ],
                          ),
                          Divider(),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    // ? Checkout this padding
                                    padding:
                                        EdgeInsets.only(left: padding * 1.6),
                                    child: Text(
                                      "Fullført",
                                      style: ServiceProvider
                                          .instance
                                          .instanceStyleService
                                          .appStyle
                                          .descTitle,
                                    ),
                                  ),
                                  Container(
                                    width: maxWidth / 2.1,
                                    // height: ServiceProvider.instance.screenService
                                    //     .getHeightByPercentage(context, 10.5),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Checkbox(
                                        value: controller
                                            .placeHolderEventItem.completed,
                                        onChanged: (val) => controller.setState(
                                            () => controller
                                                .placeHolderEventItem
                                                .completed = val),
                                        activeColor: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      // ? Checkout this padding
                                      padding:
                                          EdgeInsets.only(left: padding * 1.6),
                                      child: Text(
                                        "Påminnelse",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .descTitle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: maxWidth / 2.1,
                                      height: ServiceProvider
                                          .instance.screenService
                                          .getHeightByPercentage(context, 7.5),
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ServiceProvider
                                                  .instance
                                                  .instanceStyleService
                                                  .appStyle
                                                  .borderRadius),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              getDefaultPadding(context)),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: controller
                                                .reminderDropDownValue,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: ServiceProvider
                                                .instance
                                                .instanceStyleService
                                                .appStyle
                                                .iconSizeStandard,
                                            elevation: 0,
                                            style: ServiceProvider
                                                .instance
                                                .instanceStyleService
                                                .appStyle
                                                .textFieldInput,
                                            underline: Container(
                                              height: 0,
                                            ),
                                            onChanged: (String newValue) {
                                              FirebaseMessaging()
                                                  .requestNotificationPermissions(
                                                      const IosNotificationSettings(
                                                sound: true,
                                                alert: true,
                                                badge: true,
                                              ));

                                              controller.firstBuild = false;

                                              if (controller
                                                      .placeHolderEventItem
                                                      .timeStamp !=
                                                  null) {
                                                if (controller
                                                        .placeHolderEventItem
                                                        .timeStamp
                                                        .isBefore(
                                                            DateTime.now()) &&
                                                    newValue !=
                                                        controller
                                                            .reminderItems[0]) {
                                                  controller.reminderError =
                                                      true;
                                                  controller.reminderErrorText =
                                                      "Påminnelse er ikke mulig når datoen er i fortid";
                                                } else {
                                                  controller.reminderError =
                                                      false;

                                                  controller
                                                          .reminderDropDownValue =
                                                      newValue;

                                                  int add;

                                                  controller
                                                          .placeHolderEventItem
                                                          .reminderString =
                                                      newValue;

                                                  switch (newValue) {
                                                    case "ingen":
                                                      break;
                                                    case "1 dag før":
                                                      add = 60 * 24;
                                                      break;
                                                    case "2 dager før":
                                                      add = 60 * 48;
                                                      break;
                                                    case "1 uke før":
                                                      add = 60 * 24 * 7;
                                                      break;

                                                    default:
                                                      add = 60 * 24;
                                                      break;
                                                  }
                                                  if (add != null)
                                                    controller
                                                            .placeHolderEventItem
                                                            .reminder =
                                                        controller
                                                            .placeHolderEventItem
                                                            .timeStamp
                                                            .subtract(Duration(
                                                                minutes: add));
                                                }
                                              } else {
                                                controller.reminderError = true;
                                                controller
                                                  ..reminderErrorText =
                                                      "Vennligst velg en dato først";
                                              }
                                              controller.setState(() {});
                                            },
                                            items: controller.reminderItems
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: getDefaultPadding(
                                                              context) *
                                                          3),
                                                  child: Text(
                                                    value,
                                                    style: value == "Ingen"
                                                        ? ServiceProvider
                                                            .instance
                                                            .instanceStyleService
                                                            .appStyle
                                                            .body1
                                                        : ServiceProvider
                                                            .instance
                                                            .instanceStyleService
                                                            .appStyle
                                                            .textFieldInput,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.reminderError)
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: padding * 2, top: padding * 2),
                                    child: Text(
                                      controller.reminderErrorText,
                                      style: ServiceProvider
                                          .instance
                                          .instanceStyleService
                                          .appStyle
                                          .disabledColoredText,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Divider(),
                          PrimaryTextField(
                              asListTile: true,
                              initValue: controller.placeHolderEventItem.note,
                              hintText: "Notat",
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.newline,
                              textInputType: TextInputType.text,
                              maxLines: 5,
                              validate: false,
                              textFieldType: TextFieldType.ordinary,
                              onChanged: (val) {
                                if (val.isNotEmpty) {
                                  controller.placeHolderEventItem.note = val;
                                } else
                                  controller.placeHolderEventItem.note = null;
                              }),
                          Container(
                            height: padding * 4,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (controller.pageState == PageState.edit)
                    SecondaryButton(
                      // topPadding: getDefaultPadding(context) * 6,
                      bottomPadding: 0,
                      text: "Slett",
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.pink,
                      onPressed: () => controller.onEventDelete(
                          event: controller.placeHolderEventItem),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRead(BuildContext context) {
    double padding = getDefaultPadding(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        controller.height = maxHeight;

        return Padding(
          padding: EdgeInsets.all(padding * 2),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ServiceProvider
                      .instance.instanceStyleService.appStyle.borderRadius),
                ),
                child: Column(
                  children: <Widget>[
                    if (controller.placeHolderEventItem.timeStamp != null)
                      Padding(
                        padding: EdgeInsets.all(padding * 2),
                        child: Row(
                          children: <Widget>[
                            basicContainer2(
                              child: Text(
                                "Dato:",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.descTitle,
                              ),
                            ),
                            Container(
                              width: padding,
                            ),
                            Flexible(
                              child: Text(
                                formatDate(
                                    date: controller
                                        .placeHolderEventItem.timeStamp),
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (controller.placeHolderEventItem.timeStamp != null)
                      Padding(
                        padding: EdgeInsets.all(padding * 2),
                        child: Row(
                          children: <Widget>[
                            basicContainer2(
                              child: Text(
                                "Tidspunkt:",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.descTitle,
                              ),
                            ),
                            Container(
                              width: padding,
                            ),
                            Flexible(
                              child: Text(
                                formatDate(
                                    date: controller
                                        .placeHolderEventItem.timeStamp,
                                    time: true),
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (controller.placeHolderEventItem.reminder != null)
                      Padding(
                        padding: EdgeInsets.all(padding * 2),
                        child: Row(
                          children: <Widget>[
                            basicContainer2(
                              child: Text(
                                "Påminnelse:",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.descTitle,
                              ),
                            ),
                            Container(
                              width: padding,
                            ),
                            Flexible(
                              child: Text(
                                controller.placeHolderEventItem.reminderString,
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (controller.placeHolderEventItem.note != null)
                      Padding(
                        padding: EdgeInsets.all(padding * 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IntrinsicHeight(
                              child: basicContainer2(
                                child: Text(
                                  "Notat:",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.descTitle,
                                ),
                              ),
                            ),
                            Container(
                              width: padding,
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: padding),
                                child: Text(
                                  controller.placeHolderEventItem.note,
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
