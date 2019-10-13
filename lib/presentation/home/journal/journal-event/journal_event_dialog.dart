import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
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

  PageState pageState;

  Widget popIcon;

  List<String> reminderItems = [
    "Ingen",
    '5 minutter før',
    '30 minutter før',
    '1 time før',
    '2 timer før',
    '1 dag før',
  ];

  JournalEventDialogController(
      {this.eventItem,
      this.parentDocRef,
      this.onSave,
      this.pageState,
      this.categoryItem});

  @override
  initState() {
    popIcon = InkWell(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.close,
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        size: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      ),
    );
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

    if (controller.pageState != PageState.read) return buildEdit(context);
    return buildRead(context);
  }

  Widget buildEdit(BuildContext context) {
    PrimaryTextField titleTextField = PrimaryTextField(
      initValue: controller.placeHolderEventItem.title,
      textCapitalization: TextCapitalization.sentences,
      textInputType: TextInputType.text,
      autoFocus: controller.placeHolderEventItem.title == ""
          ? controller.firstBuild
          : false,
      hintText: "Tittel",
      onSaved: (val) => controller.placeHolderEventItem.title = val,
      validate: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: () => controller.hasFocus = false,
    );

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
                                        child: Icon(
                                          Icons.delete,
                                          size: ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .iconSizeStandard,
                                          color: controller.pageState ==
                                                  PageState.create
                                              ? Colors.transparent
                                              : ServiceProvider
                                                  .instance
                                                  .instanceStyleService
                                                  .appStyle
                                                  .textGrey,
                                        ),
                                        onTap: () {
                                          if (controller.pageState ==
                                              PageState.edit) {
                                            controller.deleteEventItem();

                                            controller.onSave(null);
                                            Navigator.pop(context);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    width: constraints.maxWidth * 0.935,
                                    child: titleTextField),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: constraints.maxWidth * 0.5,
                                      child: Column(
                                        children: <Widget>[
                                          controller.basicContainer(
                                            child: DateTimePicker(
                                              controller:
                                                  DateTimePickerController(
                                                      validate: false,
                                                      width:
                                                          constraints.maxWidth /
                                                              2.3,
                                                      overrideInitialDate: controller
                                                                  .placeHolderEventItem
                                                                  .timeStamp ==
                                                              null
                                                          ? true
                                                          : false,
                                                      onConfirmed: (date) {
                                                        controller
                                                            .placeHolderEventItem
                                                            .timeStamp = DateTime(
                                                          date.year,
                                                          date.month,
                                                          date.day,
                                                          controller
                                                                  .placeHolderEventItem
                                                                  .timeStamp
                                                                  ?.hour ??
                                                              DateTime.now()
                                                                  .hour,
                                                          controller
                                                                  .placeHolderEventItem
                                                                  .timeStamp
                                                                  ?.minute ??
                                                              DateTime.now()
                                                                  .minute,
                                                        );
                                                      },
                                                      initialDate: controller
                                                              .placeHolderEventItem
                                                              .timeStamp ??
                                                          DateTime.now(),
                                                      title: "Dato",
                                                      label: "Dato"),
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
                                              controller:
                                                  DateTimePickerController(
                                                      validate: false,
                                                      time: true,
                                                      dateFormat: "HH-mm",
                                                      width:
                                                          constraints.maxWidth /
                                                              2.27,
                                                      overrideInitialDate: controller
                                                                  .placeHolderEventItem
                                                                  .timeStamp ==
                                                              null
                                                          ? true
                                                          : false,
                                                      onConfirmed: (date) {
                                                        controller.placeHolderEventItem.timeStamp = DateTime(
                                                            controller
                                                                    .placeHolderEventItem
                                                                    .timeStamp
                                                                    ?.year ??
                                                                DateTime.now()
                                                                    .year,
                                                            controller
                                                                    .placeHolderEventItem
                                                                    .timeStamp
                                                                    ?.month ??
                                                                DateTime.now()
                                                                    .month,
                                                            controller
                                                                    .placeHolderEventItem
                                                                    .timeStamp
                                                                    ?.day ??
                                                                DateTime.now()
                                                                    .day,
                                                            date.hour,
                                                            date.minute);
                                                        print(controller
                                                            .placeHolderEventItem
                                                            .timeStamp
                                                            .toString());
                                                      },
                                                      initialDate: controller
                                                              .placeHolderEventItem
                                                              .timeStamp ??
                                                          DateTime.now(),
                                                      title: "Tidspunkt",
                                                      label: "Tidspunkt"),
                                            ),
                                          ),
                                          Divider(),
                                          controller.basicContainer(
                                            child: Card(
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
                                                    getDefaultPadding(context)),
                                                child: Container(
                                                  width: constraints.maxWidth /
                                                      2.5,
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
                                                    elevation: 16,
                                                    style: ServiceProvider
                                                        .instance
                                                        .instanceStyleService
                                                        .appStyle
                                                        .body1,
                                                    underline: Container(
                                                      height: 0,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
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
                                                            case "5 minutter før":
                                                              add = 5;
                                                              break;
                                                            case "30 minutter før":
                                                              add = 30;
                                                              break;
                                                            case "1 time før":
                                                              add = 60;
                                                              break;
                                                            case "2 timer før":
                                                              add = 120;
                                                              break;
                                                            case "1 dag før":
                                                              add = 60 * 24;
                                                              print("dasd");
                                                              break;

                                                            default:
                                                          }
                                                          if (add != null)
                                                            controller
                                                                    .placeHolderEventItem
                                                                    .reminder =
                                                                controller
                                                                    .placeHolderEventItem
                                                                    .timeStamp
                                                                    .add(Duration(
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
                                                          child: Text(
                                                            value,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                Expanded(
                                  child: Container(
                                    width: constraints.maxWidth * 0.935,
                                    child: PrimaryTextField(
                                        initValue: controller
                                            .placeHolderEventItem.note,
                                        hintText: "Beskrivelse",
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.done,
                                        textInputType: TextInputType.text,
                                        maxLines: 5,
                                        validate: false,
                                        onSaved: (val) {
                                          if (val != "")
                                            controller.placeHolderEventItem
                                                .note = val;
                                          else
                                            controller.placeHolderEventItem
                                                .note = null;
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: PrimaryButton(
                            controller: PrimaryButtonController(
                                color: ServiceProvider.instance
                                    .instanceStyleService.appStyle.green,
                                text: "Lagre",
                                onPressed: () {
                                  controller._formKey.currentState.save();
                                  if (controller
                                          .placeHolderEventItem.title.length >
                                      0) {
                                    if (controller.eventItem == null) {
                                      controller.categoryItem.journalEventItems
                                          .add(controller.placeHolderEventItem);

                                      JournalEventProvider().create(
                                          model:
                                              controller.placeHolderEventItem,
                                          id: controller
                                              .categoryItem.docRef.path);
                                    } else {
                                      JournalEventProvider().update(
                                          model:
                                              controller.placeHolderEventItem);
                                    }
                                    controller.onSave(
                                        controller.placeHolderEventItem);
                                    Navigator.pop(context);
                                  }
                                }),
                          ),
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
                    IconButton(
                      onPressed: () => controller.setState(
                          () => controller.pageState = PageState.edit),
                      icon: Icon(Icons.edit),
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.textGrey,
                      iconSize: ServiceProvider.instance.instanceStyleService
                          .appStyle.iconSizeStandard,
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
                            Text(
                                formatDate(
                                    date: controller
                                        .placeHolderEventItem.timeStamp),
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1),
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
                            Text(
                              formatDate(
                                  date:
                                      controller.placeHolderEventItem.timeStamp,
                                  time: true),
                              style: ServiceProvider
                                  .instance.instanceStyleService.appStyle.body1,
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
                            Text(
                              controller.placeHolderEventItem.reminderString,
                              style: ServiceProvider
                                  .instance.instanceStyleService.appStyle.body1,
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
