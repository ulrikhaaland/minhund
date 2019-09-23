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
              title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title ?? "N/A",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.titleGrey,
                  )),
              children: <Widget>[
                DatePickerWidget(
                  dateFormat: dateFormat ?? "dd-MM-yyyy",
                  onConfirm: (DateTime selectedTime, List<int> list) {
                    _setCtrlrText(selectedTime);
                    onConfirmed(selectedTime);
                  },
                  // locale: DateTimePickerLocale.no,
                  pickerTheme: DateTimePickerTheme(
                    cancelTextStyle: ServiceProvider
                        .instance.instanceStyleService.appStyle.cancel,
                    confirmTextStyle: ServiceProvider
                        .instance.instanceStyleService.appStyle.confirm,
                  ),
                  initialDateTime: initialDate ??
                      DateTime.now().subtract(Duration(days: 10000)),
                ),
              ],
            ),
          );
        });
  }
}

class DateTimePicker extends BaseView {
  final DateTimePickerController controller;

  DateTimePicker({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PrimaryTextField(
        textEditingController: controller._textCtrlr,
        focusNode: controller._textNode,
        labelText: controller.label,
      ),
    );
  }
}
