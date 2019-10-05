import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class DropDownBtnController extends BaseController {
  final double width;
  final void Function(String value) onChanged;
  final VoidCallback onAddNew;
  final List<String> items;

  String value;

  DropDownBtnController({
    this.width,
    this.onChanged,
    this.items,
    this.value,
    this.onAddNew,
  });

  @override
  void initState() {
    if (onAddNew != null) items.add("Legg til ny");
    super.initState();
  }
}

class DropDownBtn extends BaseView {
  final DropDownBtnController controller;

  DropDownBtn({this.controller});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ServiceProvider
            .instance.instanceStyleService.appStyle.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(getDefaultPadding(context)),
        child: Container(
          width: controller.width / 2.5,
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.value,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: ServiceProvider
                .instance.instanceStyleService.appStyle.iconSizeStandard,
            elevation: 16,
            style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
            underline: Container(
              height: 0,
            ),
            onChanged: (String newValue) {
              if (controller.onAddNew != null) {
                if (newValue == "Legg til ny") {
                  controller.onAddNew();
                } else {
                  controller.onChanged(newValue);
                }
              } else {
                controller.onChanged(newValue);
              }
            },
            items:
                controller.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: getDefaultPadding(context) * 3),
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
