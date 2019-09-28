import 'dart:async';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DateTimePickerController extends BaseController {
  final void Function(DateTime) onConfirmed;
  final String dateFormat;
  final String label;
  final DateTime initialDate;
  final String title;

  bool canSave = false;

  TextEditingController _textCtrlr = TextEditingController();

  FocusNode _textNode = FocusNode();

  DateTimePickerController(
      {this.onConfirmed,
      this.title,
      this.dateFormat,
      this.label,
      this.initialDate});

  @override
  void initState() {
    super.initState();
    _textNode.addListener(() => openDatePicker());
    initialDate != null ? _setCtrlrText(initialDate) : null;
    if (_textCtrlr.text != "" && _textCtrlr.text != null) canSave = true;
  }

  @override
  void dispose() {
    _textCtrlr.dispose();
    _textNode.dispose();
    super.dispose();
  }

  void openDatePicker({TextEditingController ctrlr}) {
    FocusScope.of(context).unfocus();
    _birthDialog(
      context: context,
    );
  }

  _setCtrlrText(DateTime date) {
    String month;
    date.month.toString().length == 1
        ? month = "0" + date.month.toString()
        : month = date.month.toString();
    setState(() {
      if (date == null) {
        _textCtrlr.text = "";
      } else {
        switch (dateFormat) {
          case ("dd-MM-yyyy"):
            _textCtrlr.text = "${date.day}-$month-${date.year}";
            break;
          case ("MM-yyyy"):
            _textCtrlr.text = "$month-${date.year}";
            break;

          default:
            _textCtrlr.text = "${date.day}-$month-${date.year}";
        }
      }
    });
  }

  Future<void> _birthDialog({BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(true);
            },
            child: SimpleDialog(
              backgroundColor: Colors.white,
              title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title ?? "N/A",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.title,
                  )),
              children: <Widget>[
                DatePickerWidget(
                  maxDateTime: DateTime.now(),
                  dateFormat: dateFormat ?? "dd-MM-yyyy",
                  onConfirm: (DateTime selectedTime, List<int> list) {
                    canSave = true;
                    _setCtrlrText(selectedTime);
                    onConfirmed(selectedTime);
                  },
                  locale: DateTimePickerLocale.hu,
                  pickerTheme: DateTimePickerTheme(
                    itemTextStyle: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1,
                    backgroundColor: Colors.white,
                    cancelTextStyle: ServiceProvider
                        .instance.instanceStyleService.appStyle.cancel,
                    confirmTextStyle: ServiceProvider
                        .instance.instanceStyleService.appStyle.confirm,
                  ),
                  initialDateTime: initialDate ??
                      DateTime.now().subtract(Duration(days: 2000)),
                ),
              ],
            ),
          );
        });
  }
}

class DateTimePicker extends BaseView {
  final DateTimePickerController controller;

  bool canSave;

  DateTimePicker({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    canSave = controller.canSave;
    return PrimaryTextField(
      validate: true,
      textEditingController: controller._textCtrlr,
      focusNode: controller._textNode,
      hintText: controller.label,
    );
  }
}
