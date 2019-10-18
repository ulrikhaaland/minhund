import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/fcm/reminder.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/fcm_provider.dart';
import 'package:minhund/provider/journal_event_provider.dart';
import 'package:minhund/service/service_provider.dart';

class JournalEventDialogController extends BaseController {
  final void Function(JournalEventItem eventItem) onSave;

  JournalEventItem eventItem;

  JournalEventItem placeHolderEventItem;

  final DocumentReference parentDocRef;

  String reminderDropDownValue;

  final JournalCategoryItem categoryItem;

  double height;

  bool reminderError = false;

  String reminderErrorText = "";

  FocusScopeNode scopeNode = FocusScopeNode();

  final _formKey = GlobalKey<FormState>();

  bool firstBuild = true;

  bool hasFocus = true;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  PageState pageState;

  final User user;

  Widget popIcon;

  bool canSave = false;

  DateTimePickerController datePickerController;

  DateTimePickerController timePickerController;

  List<String> reminderItems = [
    "Ingen",
    '1 dag før',
    '2 dager før',
    '1 uke før',
  ];

  JournalEventDialogController(
      {this.eventItem,
      this.user,
      this.parentDocRef,
      this.onSave,
      this.pageState,
      this.categoryItem});

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

    super.initState();
  }

  @override
  void dispose() {
    scopeNode.dispose();
    super.dispose();
  }

  void deleteEventItem() {
    JournalEventProvider().delete(model: placeHolderEventItem);

    categoryItem.journalEventItems
        .removeWhere((item) => item.id == placeHolderEventItem.id);

    onSave(null);

    Navigator.pop(context);
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
      }
      if (eventItem == null) {
        categoryItem.journalEventItems.add(placeHolderEventItem);

        JournalEventProvider()
            .create(model: placeHolderEventItem, id: categoryItem.docRef.path)
            .then((item) {
          if (reminder != null) {
            reminder.eventId = item.documentID;
            FCMProvider()
                .set(id: "reminders/${reminder.eventId}", model: reminder);
          }
        });
      } else {
        JournalEventProvider().update(model: placeHolderEventItem).then((_) {
          if (reminder != null) {
            reminder.eventId = placeHolderEventItem.id;
            Firestore.instance
                .document("reminders/${reminder.eventId}")
                .setData(reminder.toJson());
          }
        });
      }
      onSave(placeHolderEventItem);
      Navigator.pop(context);
    }
  }

  Widget basicContainer({
    Widget child,
    double width,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      height: height * 0.1,
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
      height: height * 0.05,
      width: width != null ? (width * 0.935) / 2 : null,
      child: child,
    );
  }
}

class JournalEventDialog extends BaseView {
  final JournalEventDialogController controller;

  JournalEventDialog({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

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

  Widget buildEdit(BuildContext context) {
    double padding = getDefaultPadding(context);

    controller.hasFocus = controller.scopeNode.hasFocus;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(padding * 2),
        child: FocusScope(
          node: controller.scopeNode,
          child: Form(
            key: controller._formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                controller.datePickerController = DateTimePickerController(
                    validate: false,
                    width: constraints.maxWidth / 2.3,
                    overrideInitialDate:
                        controller.placeHolderEventItem.timeStamp == null
                            ? true
                            : false,
                    onConfirmed: (date) {
                      controller.placeHolderEventItem.timeStamp = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          controller.placeHolderEventItem.timeStamp?.hour ?? 11,
                          controller.placeHolderEventItem.timeStamp?.minute ??
                              11,
                          11);

                      // if (controller.placeHolderEventItem.timeStamp.second ==
                      //     11)
                      //   Timer(
                      //       Duration(milliseconds: 50),
                      //       () => controller.timePickerController
                      //           .openDatePicker(context));
                    },
                    initialDate: controller.placeHolderEventItem.timeStamp ??
                        DateTime.now(),
                    title: "Dato",
                    label: "Dato");

                controller.timePickerController = DateTimePickerController(
                    validate: false,
                    time: true,
                    dateFormat: "HH-mm",
                    width: constraints.maxWidth / 2.27,
                    overrideInitialDate:
                        controller.placeHolderEventItem.timeStamp == null
                            ? true
                            : false,
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
                      print(
                          controller.placeHolderEventItem.timeStamp.toString());
                    },
                    initialDate: controller.placeHolderEventItem.timeStamp ??
                        DateTime.now(),
                    title: "Tidspunkt",
                    label: "Tidspunkt");

                controller.height = constraints.maxHeight;
                return Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Container(
                            height: constraints.maxHeight * 0.8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                controller.basicContainer(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      controller.popIcon,
                                      Text(
                                        controller.pageState == PageState.create
                                            ? "Ny oppgave"
                                            : "Rediger oppgave",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .smallTitle,
                                      ),
                                      InkWell(
                                        onTap: () => controller.saveEventItem(),
                                        child: Container(
                                          width: ServiceProvider
                                              .instance.screenService
                                              .getWidthByPercentage(
                                                  context, 15),
                                          decoration: BoxDecoration(
                                              color: controller.canSave
                                                  ? ServiceProvider
                                                      .instance
                                                      .instanceStyleService
                                                      .appStyle
                                                      .green
                                                  : Colors.grey[400],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      ServiceProvider
                                                          .instance
                                                          .instanceStyleService
                                                          .appStyle
                                                          .borderRadius))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Lagre",
                                              style: ServiceProvider
                                                  .instance
                                                  .instanceStyleService
                                                  .appStyle
                                                  .body1
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // InkWell(
                                      //   child: Icon(
                                      //     Icons.delete,
                                      //     size: ServiceProvider
                                      //         .instance
                                      //         .instanceStyleService
                                      //         .appStyle
                                      //         .iconSizeStandard,
                                      //     color: controller.pageState ==
                                      //             PageState.create
                                      //         ? Colors.transparent
                                      //         : ServiceProvider
                                      //             .instance
                                      //             .instanceStyleService
                                      //             .appStyle
                                      //             .textGrey,
                                      //   ),
                                      //   onTap: () {
                                      //     if (controller.pageState ==
                                      //         PageState.edit) {
                                      //       controller.deleteEventItem();

                                      //       controller.onSave(null);
                                      //       Navigator.pop(context);
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth * 0.935,
                                  child: PrimaryTextField(
                                    initValue:
                                        controller.placeHolderEventItem.title,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputType: TextInputType.text,
                                    autoFocus:
                                        controller.placeHolderEventItem.title ==
                                                ""
                                            ? controller.firstBuild
                                            : false,
                                    asTextField: true,
                                    hintText: "Tittel",
                                    onChanged: (val) {
                                      if (val.isNotEmpty)
                                        controller.canSave = true;
                                      else
                                        controller.canSave = false;
                                      controller.placeHolderEventItem.title =
                                          val;
                                      controller.setState(() {});
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: () {
                                      controller.hasFocus = false;
                                      controller.datePickerController
                                          .openDatePicker(context);
                                    },
                                  ),
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: constraints.maxWidth * 0.5,
                                      child: Column(
                                        children: <Widget>[
                                          controller.basicContainer(
                                            child: DateTimePicker(
                                              controller: controller
                                                  .datePickerController,
                                            ),
                                          ),
                                          Divider(),
                                          controller.basicContainer(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: padding * 1.6),
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
                                          if (controller.reminderError)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: padding * 2),
                                              child: Text(
                                                controller.reminderErrorText,
                                                style: ServiceProvider
                                                    .instance
                                                    .instanceStyleService
                                                    .appStyle
                                                    .transparentDisabledColoredText,
                                              ),
                                            ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: constraints.maxWidth * 0.5,
                                      child: Column(
                                        children: <Widget>[
                                          controller.basicContainer(
                                            child: DateTimePicker(
                                                controller: controller
                                                    .timePickerController),
                                          ),
                                          Divider(),
                                          controller.basicContainer(
                                            child: Container(
                                              width:
                                                  constraints.maxWidth / 2.25,
                                              height: ServiceProvider
                                                  .instance.screenService
                                                  .getHeightByPercentage(
                                                      context, 9.5),
                                              child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(ServiceProvider
                                                          .instance
                                                          .instanceStyleService
                                                          .appStyle
                                                          .borderRadius),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      getDefaultPadding(
                                                          context)),
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    value: controller
                                                        .reminderDropDownValue,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
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
                                                    onChanged:
                                                        (String newValue) {
                                                      FirebaseMessaging()
                                                          .requestNotificationPermissions(
                                                              const IosNotificationSettings(
                                                        sound: true,
                                                        alert: true,
                                                        badge: true,
                                                      ));

                                                      if (!controller.user
                                                          .allowsNotifications) {
                                                        controller._fcm
                                                            .requestNotificationPermissions(
                                                                IosNotificationSettings());
                                                      }
                                                      controller.firstBuild =
                                                          false;

                                                      if (controller
                                                              .placeHolderEventItem
                                                              .timeStamp !=
                                                          null) {
                                                        if (controller
                                                            .placeHolderEventItem
                                                            .timeStamp
                                                            .isBefore(DateTime
                                                                .now())) {
                                                          controller
                                                                  .reminderError =
                                                              true;
                                                          controller
                                                                  .reminderErrorText =
                                                              "Påminnelse er ikke mulig når datoen er i fortid";
                                                        } else {
                                                          controller
                                                                  .reminderError =
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
                                                                        minutes:
                                                                            add));
                                                        }
                                                      } else {
                                                        controller
                                                                .reminderError =
                                                            true;
                                                        controller
                                                          ..reminderErrorText =
                                                              "Vennligst velg en dato først";
                                                      }
                                                      controller
                                                          .setState(() {});
                                                    },
                                                    items: controller
                                                        .reminderItems
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: getDefaultPadding(
                                                                      context) *
                                                                  3),
                                                          child: Container(
                                                            width: ServiceProvider
                                                                .instance
                                                                .screenService
                                                                .getWidthByPercentage(
                                                                    context,
                                                                    80),
                                                            child: Text(
                                                              value,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (controller.reminderError)
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: padding * 2),
                                                child: Text(
                                                  controller.reminderErrorText,
                                                  style: ServiceProvider
                                                      .instance
                                                      .instanceStyleService
                                                      .appStyle
                                                      .disabledColoredText,
                                                ),
                                              ),
                                            ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: constraints.maxWidth * 0.935,
                                  child: PrimaryTextField(
                                      initValue:
                                          controller.placeHolderEventItem.note,
                                      hintText: "Beskrivelse",
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textInputAction: TextInputAction.done,
                                      textInputType: TextInputType.text,
                                      maxLines: 5,
                                      validate: false,
                                      asTextField: true,
                                      onChanged: (val) {
                                        if (val.isNotEmpty) {
                                          controller.placeHolderEventItem.note =
                                              val;
                                        } else
                                          controller.placeHolderEventItem.note =
                                              null;
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (controller.pageState == PageState.edit)
                          SecondaryButton(
                            topPadding: 0,
                            text: "Slett",
                            color: ServiceProvider
                                .instance.instanceStyleService.appStyle.pink,
                            onPressed: () => controller.deleteEventItem(),
                          ),
                      ],
                    ),
                    if (controller.hasFocus || controller.firstBuild)
                      GestureDetector(
                        onTap: () => controller.setState(() {
                          controller.scopeNode.unfocus();
                          controller.firstBuild = false;
                        }),
                        child: Container(
                          color: Colors.transparent,
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                        ),
                      ),
                  ],
                );
              },
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
        controller.height = constraints.maxHeight;

        return Padding(
          padding: EdgeInsets.all(padding * 2),
          child: Column(
            children: <Widget>[
              controller.basicContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    controller.popIcon,
                    Flexible(
                      child: Text(
                        controller.placeHolderEventItem.title ?? "",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => controller.setState(
                              () => controller.pageState = PageState.edit),
                          icon: Icon(Icons.edit),
                          color: ServiceProvider
                              .instance.instanceStyleService.appStyle.textGrey,
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeStandard,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                            controller.basicContainer2(
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
                            controller.basicContainer2(
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
                            controller.basicContainer2(
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
                            controller.basicContainer2(
                              child: Text(
                                "Beskrivelse:",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.descTitle,
                              ),
                            ),
                            Container(
                              width: padding,
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: padding * 0.6),
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
