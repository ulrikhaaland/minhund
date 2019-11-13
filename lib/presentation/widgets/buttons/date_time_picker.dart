import 'dart:async';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:minhund/helper/helper.dart';
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

  final DateTime minDateTime;

  final double width;

  bool canSave = false;

  final bool asListTile;

  bool enabled;

  final bool validate;

  final bool time;

  final bool overrideInitialDate;

  TextEditingController _textCtrlr = TextEditingController();

  FocusNode _textNode = FocusNode();

  Icon confirmIcon;
  Icon cancelIcon;

  DateTimePickerController(
      {this.onConfirmed,
      this.title,
      this.dateFormat,
      this.minDateTime,
      this.asListTile = false,
      this.label,
      this.initialDate,
      this.width,
      this.enabled = true,
      this.time = false,
      this.validate = true,
      this.overrideInitialDate = false});

  @override
  void initState() {
    confirmIcon = Icon(
      Icons.check,
      color: ServiceProvider.instance.instanceStyleService.appStyle.green,
      size: ServiceProvider
          .instance.instanceStyleService.appStyle.iconSizeStandard,
    );
    cancelIcon = Icon(
      Icons.close,
      color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
      size: ServiceProvider
          .instance.instanceStyleService.appStyle.iconSizeStandard,
    );
    super.initState();
    _textNode
        .addListener(() => _textNode.hasFocus ? openDatePicker(context) : null);
    if (initialDate != null && overrideInitialDate != true)
      _setCtrlrText(initialDate);
    if (_textCtrlr.text != "" && _textCtrlr.text != null) canSave = true;
  }

  @override
  void dispose() {
    _textCtrlr.dispose();
    _textNode.dispose();
    super.dispose();
  }

  void openDatePicker(BuildContext context) {
    FocusScope.of(context).unfocus();
    _birthDialog(
      context: context,
    );
  }

  _setCtrlrText(DateTime date) {
    _textCtrlr.text = formatDate(time: time, date: date);

    setState(() {});
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
                    title ?? label ?? "N/A",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.smallTitle,
                  )),
              backgroundColor: Colors.white,
              children: <Widget>[
                if (time == true)
                  TimePickerWidget(
                    dateFormat: dateFormat ?? "HH-mm",
                    onConfirm: (DateTime selectedTime, List<int> list) {
                      canSave = true;
                      _setCtrlrText(selectedTime);
                      onConfirmed(selectedTime);
                    },
                    locale: DateTimePickerLocale.hu,
                    pickerTheme: DateTimePickerTheme(
                      confirm: confirmIcon,
                      cancel: cancelIcon,
                      itemTextStyle: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                      backgroundColor: Colors.white,
                      cancelTextStyle: ServiceProvider
                          .instance.instanceStyleService.appStyle.cancel,
                      confirmTextStyle: ServiceProvider
                          .instance.instanceStyleService.appStyle.confirm,
                    ),
                    initDateTime: initialDate ??
                        DateTime.now().subtract(Duration(days: 2000)),
                  ),
                if (time != true)
                  DatePickerWidget(
                    minDateTime: minDateTime,
                    // maxDateTime: DateTime.now(),
                    dateFormat: dateFormat ?? "dd-MM-yyyy",
                    onConfirm: (DateTime selectedTime, List<int> list) {
                      canSave = true;
                      _setCtrlrText(selectedTime);
                      onConfirmed(selectedTime);
                    },
                    locale: DateTimePickerLocale.hu,
                    pickerTheme: DateTimePickerTheme(
                      confirm: confirmIcon,
                      cancel: cancelIcon,
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
    return Padding(
      padding:  EdgeInsets.only(bottom: getDefaultPadding(context) * 2),
      child: PrimaryTextField(
        asListTile: controller.asListTile,
        autoFocus: false,
        enabled: controller.enabled,
        validate: controller.validate ?? true,
        textEditingController: controller._textCtrlr,
        focusNode: controller._textNode,
        hintText: controller.label,
        width: controller.width,
      ),
    );
  }
}
