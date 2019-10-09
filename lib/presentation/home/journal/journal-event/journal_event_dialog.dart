import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/journal_event_provider.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:provider/provider.dart';

enum PageState { create, edit, read }

class JournalEventDialogController extends BaseController {
  final VoidCallback onSave;

  JournalEventItem eventItem;

  JournalEventItem placeHolderEventItem;

  List<JournalItem> journalItems;

  final DocumentReference parentDocRef;

  String reminderDropDownValue;

  JournalItem selectedJournalItem;

  double height;

  bool reminderError = false;

  String reminderErrorText = "";

  FocusScopeNode scopeNode = FocusScopeNode();

  bool addNewCategory = false;

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
      this.journalItems,
      this.parentDocRef,
      this.onSave,
      this.pageState});

  @override
  initState() {
    popIcon = InkWell(
      onTap: () => addNewCategory
          ? setState(() => addNewCategory = false)
          : Navigator.pop(context),
      child: Icon(
        Icons.close,
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        size:
            ServiceProvider.instance.instanceStyleService.appStyle.iconSizeBig,
      ),
    );
    if (eventItem == null) {
      placeHolderEventItem = JournalEventItem(title: "");
      if (journalItems.firstWhere((item) => item.title == "Legg til ny",
              orElse: () => null) ==
          null) journalItems.add(JournalItem(title: "Legg til ny"));

      reminderDropDownValue = "Ingen";

      selectedJournalItem = journalItems[0];
    } else {
      firstBuild = false;
      placeHolderEventItem = JournalEventItem(
          docRef: eventItem.docRef,
          title: eventItem.title,
          timeStamp: eventItem.timeStamp,
          note: eventItem.note,
          reminder: eventItem.reminder,
          reminderString: eventItem.reminderString);
      reminderDropDownValue = placeHolderEventItem.reminderString ?? "Ingen";
      journalItems.forEach((item) {
        if (item.journalEventItems != null) if (item.journalEventItems
            .contains(eventItem)) selectedJournalItem = item;
      });
    }

    super.initState();
  }

  void deleteEventItem() {
    JournalEventProvider().delete(model: eventItem);

    journalItems.forEach((item) {
      if (item.journalEventItems != null) {
        item.journalEventItems.remove(eventItem);
      }
    });
  }

  Widget basicContainer({Widget child, double width}) {
    return Container(
      alignment: Alignment.centerLeft,
      height: height * 0.1,
      width: width != null ? (width * 0.935) / 2 : null,
      child: child,
    );
  }

  Widget basicContainer2({Widget child, double width}) {
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

    if (controller.journalItems == null)
      controller.journalItems = Provider.of<Dog>(context).journalItems;

    if (controller.pageState != PageState.read) return buildEdit(context);
    return buildRead(context);
  }

  Widget buildEdit(BuildContext context) {
    PrimaryTextField addTextField = PrimaryTextField(
      textCapitalization: TextCapitalization.sentences,
      validate: true,
      onSaved: (val) {
        if (val != "Legg til ny") {
          controller.journalItems.insert(
            controller.journalItems.length - 1,
            JournalItem(
                title: val,
                journalEventItems: [],
                sortIndex: controller.journalItems.length - 1),
          );
        }
      },
      textInputType: TextInputType.text,
      textInputAction: TextInputAction.done,
      hintText: "Kategori-navn",
      onFieldSubmitted: () => controller.hasFocus = false,
    );

    PrimaryTextField titleTextField = PrimaryTextField(
      initValue: controller.placeHolderEventItem.title,
      textCapitalization: TextCapitalization.sentences,
      textInputType: TextInputType.text,
      autoFocus: controller.placeHolderEventItem.title == ""
          ? controller.firstBuild
          : false,
      // asTextField: true,
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
                    if (controller.addNewCategory) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          controller.basicContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                controller.popIcon,
                                Text(
                                  "Legg til ny kategori",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.title,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.transparent,
                                  onPressed: () => null,
                                )
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              width: constraints.maxWidth * 0.935,
                              child: addTextField),
                          PrimaryButton(
                            controller: PrimaryButtonController(
                              text: "Legg til",
                              color: ServiceProvider
                                  .instance.instanceStyleService.appStyle.green,
                              onPressed: () {
                                controller._formKey.currentState.save();
                                if (validateTextFields(
                                    singleTextField: addTextField)) {
                                  controller.selectedJournalItem =
                                      controller.journalItems[
                                          controller.journalItems.length - 2];

                                  JournalProvider().create(
                                      model: controller.selectedJournalItem,
                                      id: controller.parentDocRef.path);
                                  controller.addNewCategory = false;
                                  controller.refresh();
                                  // controller.setState(
                                  //     () => );
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ] else ...[
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
                                          controller.pageState ==
                                                  PageState.create
                                              ? "Ny oppgave"
                                              : "Rediger oppgave",
                                          style: ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .title,
                                        ),
                                        InkWell(
                                          child: Icon(
                                            Icons.delete,
                                            size: ServiceProvider
                                                .instance
                                                .instanceStyleService
                                                .appStyle
                                                .iconSizeBig,
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

                                              controller.onSave();
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
                                                        width: constraints
                                                                .maxWidth /
                                                            2.3,
                                                        overrideInitialDate:
                                                            controller.placeHolderEventItem
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
                                                  "Kategori",
                                                  style: ServiceProvider
                                                      .instance
                                                      .instanceStyleService
                                                      .appStyle
                                                      .descTitle,
                                                ),
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
                                                        width: constraints
                                                                .maxWidth /
                                                            2.27,
                                                        overrideInitialDate:
                                                            controller.placeHolderEventItem
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
                                                      getDefaultPadding(
                                                          context)),
                                                  child: Container(
                                                    width:
                                                        constraints.maxWidth /
                                                            2.5,
                                                    child: DropdownButton(
                                                      isExpanded: true,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
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
                                                      value: controller
                                                              .selectedJournalItem
                                                              .title ??
                                                          "",
                                                      onChanged: (newValue) {
                                                        controller.firstBuild =
                                                            false;
                                                        if (newValue ==
                                                            "Legg til ny") {
                                                          controller
                                                                  .addNewCategory =
                                                              true;
                                                          controller
                                                                  .selectedJournalItem =
                                                              controller
                                                                  .journalItems[0];
                                                        } else {
                                                          controller
                                                              .placeHolderEventItem
                                                              .category = newValue;
                                                          controller
                                                                  .selectedJournalItem =
                                                              controller
                                                                  .journalItems
                                                                  .firstWhere((item) =>
                                                                      item.title ==
                                                                      newValue);
                                                        }

                                                        controller
                                                            .setState(() {});
                                                      },
                                                      items: controller
                                                          .journalItems
                                                          .map((item) =>
                                                              item.title)
                                                          .toList()
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
                                                      getDefaultPadding(
                                                          context)),
                                                  child: Container(
                                                    width:
                                                        constraints.maxWidth /
                                                            2.5,
                                                    child:
                                                        DropdownButton<String>(
                                                      isExpanded: true,
                                                      value: controller
                                                          .reminderDropDownValue,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
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
                                                    controller
                                                        .reminderErrorText,
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
                                        onSaved: (val) => controller
                                            .placeHolderEventItem.note = val,
                                      ),
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
                                      if (controller.eventItem == null ||
                                          controller.placeHolderEventItem
                                                  .category !=
                                              controller.eventItem.category) {
                                        controller.selectedJournalItem
                                            .journalEventItems
                                            .add(controller
                                                .placeHolderEventItem);

                                        JournalEventProvider().create(
                                            model:
                                                controller.placeHolderEventItem,
                                            id: controller.selectedJournalItem
                                                .docRef.path);
                                        if (controller.eventItem !=
                                            null) if (controller
                                                .placeHolderEventItem
                                                .category !=
                                            controller.eventItem?.category) {
                                          controller.deleteEventItem();
                                        }
                                      } else {
                                        controller.eventItem =
                                            controller.placeHolderEventItem;
                                        JournalEventProvider().update(
                                            model: controller.eventItem);
                                      }
                                      controller.onSave();
                                      Navigator.pop(context);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (controller.hasFocus ||
                        (controller.firstBuild && !controller.addNewCategory))
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
                      iconSize: ServiceProvider
                          .instance.instanceStyleService.appStyle.iconSizeBig,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ServiceProvider
                      .instance.instanceStyleService.appStyle.borderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: <Widget>[
                      if (controller.placeHolderEventItem.timeStamp != null)
                        Row(
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
                      if (controller.placeHolderEventItem.timeStamp != null)
                        Row(
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
                      if (controller.placeHolderEventItem.reminder != null)
                        Row(
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
                      if (controller.placeHolderEventItem.note != null)
                        Row(
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
                              child: Text(
                                controller.placeHolderEventItem.note,
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
