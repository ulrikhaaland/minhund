import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/drop_down_btn.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';

class JournalListItemEventController extends BaseController {
  JournalEventItem eventItem;

  final List<JournalItem> journalItems;

  final String title;

  final void Function(JournalEventItem item) onSaved;

  String dropDownValue = "Ingen";

  JournalItem selectedJournalItem;

  double height;

  bool reminderError = false;

  String reminderErrorText = "";

  bool addNewCategory = false;

  final _formKey = GlobalKey<FormState>();

  List<Widget> textFields;

  PrimaryTextField addTextField;

  JournalListItemEventController(
      {this.eventItem, this.title, this.onSaved, this.journalItems});

  @override
  initState() {
    selectedJournalItem = journalItems[0];
    if (eventItem == null) eventItem = JournalEventItem();
    setTextFields();
    super.initState();
  }

  void setTextFields() {
    addTextField = PrimaryTextField(
      validate: true,
      onSaved: (val) => journalItems.add(JournalItem(
        title: val,
        journalEventItems: [],
        sortIndex: journalItems.length + 1,
      )),
      hintText: "Kategori-navn",
    );

    textFields = [];
  }

  Widget basicContainer({Widget child}) {
    return Container(
      alignment: Alignment.centerLeft,
      height: height * 0.1,
      child: child,
    );
  }
}

class JournalListItemEvent extends BaseView {
  final JournalListItemEventController controller;

  JournalListItemEvent({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    Widget popIcon = InkWell(
      onTap: () => controller.addNewCategory
          ? controller.setState(() => controller.addNewCategory = false)
          : Navigator.pop(context),
      child: Icon(
        Icons.close,
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        size: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      ),
    );

    double padding = getDefaultPadding(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(padding * 2),
        child: Form(
          key: controller._formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              controller.height = constraints.maxHeight;
              return Stack(
                children: <Widget>[
                  if (controller.addNewCategory) ...[
                    Column(
                      children: <Widget>[
                        controller.basicContainer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: padding * 1.6,
                                ),
                                child: Text(
                                  "Legg til ny kategori",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.smallTitle,
                                ),
                              ),
                              popIcon,
                            ],
                          ),
                        ),
                        controller.addTextField,
                        PrimaryButton(
                          controller: PrimaryButtonController(
                            text: "Legg til",
                            color: ServiceProvider
                                .instance.instanceStyleService.appStyle.green,
                            onPressed: () {
                              controller._formKey.currentState.save();
                              if (validateTextFields(
                                  singleTextField: controller.addTextField)) {
                                controller.selectedJournalItem =
                                    controller.journalItems[
                                        controller.journalItems.length - 1];

                                controller.setState(
                                    () => controller.addNewCategory = false);
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ] else ...[
                    Column(
                      children: <Widget>[
                        Container(
                          height: constraints.maxHeight * 0.8,
                          child: Column(
                            children: <Widget>[
                              controller.basicContainer(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: padding * 1.6),
                                      child: Text(
                                        controller.eventItem.title ??
                                            "Ny oppgave",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .smallTitle,
                                      ),
                                    ),
                                    popIcon,
                                  ],
                                ),
                              ),
                              controller.basicContainer(
                                child: PrimaryTextField(
                                  hintText: "Tittel",
                                  onSaved: (val) =>
                                      controller.eventItem.title = val,
                                  validate: false,
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
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: padding * 1.6),
                                            child: Text(
                                              "Kategori",
                                              style: ServiceProvider
                                                  .instance
                                                  .instanceStyleService
                                                  .appStyle
                                                  .smallTitle,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        controller.basicContainer(
                                          child: DateTimePicker(
                                            controller:
                                                DateTimePickerController(
                                                    validate: false,
                                                    width:
                                                        constraints.maxWidth /
                                                            2.2,
                                                    overrideInitialDate: true,
                                                    onConfirmed: (date) {
                                                      controller.eventItem
                                                          .timeStamp = DateTime(
                                                        date.year,
                                                        date.month,
                                                        date.day,
                                                        controller
                                                                .eventItem
                                                                .timeStamp
                                                                ?.hour ??
                                                            DateTime.now().hour,
                                                        controller
                                                                .eventItem
                                                                .timeStamp
                                                                ?.minute ??
                                                            DateTime.now()
                                                                .minute,
                                                      );
                                                      print(controller
                                                          .eventItem.timeStamp
                                                          .toString());
                                                    },
                                                    initialDate: controller
                                                        .eventItem.timeStamp,
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
                                                  .smallTitle,
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
                                          child: DropDownBtn(
                                            controller: DropDownBtnController(
                                              width: constraints.maxWidth,
                                              value: controller
                                                  .selectedJournalItem.title,
                                              items: controller.journalItems
                                                  .map((item) => item.title)
                                                  .toList(),
                                              onChanged: (title) {
                                                controller.selectedJournalItem =
                                                    controller.journalItems
                                                        .firstWhere((item) =>
                                                            item.title ==
                                                            title);

                                                controller.setState(() {});
                                              },
                                              onAddNew: () => controller
                                                  .setState(() => controller
                                                      .addNewCategory = true),
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        controller.basicContainer(
                                          child: DateTimePicker(
                                            controller:
                                                DateTimePickerController(
                                                    validate: false,
                                                    time: true,
                                                    dateFormat: "HH-mm",
                                                    width:
                                                        constraints.maxWidth /
                                                            2.2,
                                                    overrideInitialDate: true,
                                                    onConfirmed: (date) {
                                                      controller.eventItem
                                                              .timeStamp =
                                                          DateTime(
                                                              controller
                                                                      .eventItem
                                                                      .timeStamp
                                                                      ?.year ??
                                                                  DateTime.now()
                                                                      .year,
                                                              controller
                                                                      .eventItem
                                                                      .timeStamp
                                                                      ?.month ??
                                                                  DateTime.now()
                                                                      .month,
                                                              controller
                                                                      .eventItem
                                                                      .timeStamp
                                                                      ?.day ??
                                                                  DateTime.now()
                                                                      .day,
                                                              date.hour,
                                                              date.minute);
                                                      print(controller
                                                          .eventItem.timeStamp
                                                          .toString());
                                                    },
                                                    initialDate: controller
                                                        .eventItem.timeStamp,
                                                    title: "Tidspunkt",
                                                    label: "Tidspunkt"),
                                          ),
                                        ),
                                        Divider(),
                                        controller.basicContainer(
                                          child: DropDownBtn(
                                            controller: DropDownBtnController(
                                              width: constraints.maxWidth,
                                              onChanged: (newValue) {
                                                if (controller
                                                        .eventItem.timeStamp !=
                                                    null) {
                                                  if (controller
                                                      .eventItem.timeStamp
                                                      .isBefore(
                                                          DateTime.now())) {
                                                    controller.reminderError =
                                                        true;
                                                    controller
                                                            .reminderErrorText =
                                                        "Påminnelse er ikke mulig når datoen er i fortid";
                                                  } else {
                                                    controller.reminderError =
                                                        false;

                                                    controller.dropDownValue =
                                                        newValue;

                                                    int add;

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
                                                      controller.eventItem
                                                              .reminder =
                                                          controller.eventItem
                                                              .timeStamp
                                                              .add(Duration(
                                                                  minutes:
                                                                      add));
                                                  }
                                                } else {
                                                  controller.reminderError =
                                                      true;
                                                  controller.reminderErrorText =
                                                      "Vennligst velg en dato først";
                                                }
                                                controller.setState(() {});
                                              },
                                              items: <String>[
                                                "Ingen",
                                                '5 minutter før',
                                                '30 minutter før',
                                                '1 time før',
                                                '2 timer før',
                                                '1 dag før',
                                              ],
                                              value: "Ingen",
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
                                                  .disabledColoredText,
                                            ),
                                          ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              PrimaryTextField(
                                hintText: "Beskrivelse",
                                maxLines: 10,
                                validate: false,
                                onSaved: (val) =>
                                    controller.eventItem.note = val,
                              ),
                            ],
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
                                  if (validateTextFields(
                                      textFields: controller.textFields)) {
                                    controller
                                        .selectedJournalItem.journalEventItems
                                        .add(controller.eventItem);
                                    Navigator.pop(context);
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
