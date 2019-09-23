import 'dart:async';

import 'package:minhund/helper/helper.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';

enum RegExType { phone, email, password }

class PrimaryTextField extends StatefulWidget {
  final String initValue;
  final FocusNode focusNode;
  final VoidCallback onFieldSubmitted;
  final Function(String val) onSaved;
  final String labelText;
  final String helperText;
  final String hintText;
  final TextStyle helperStyle;
  final TextStyle labelStyle;
  final TextStyle style;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final Color cursorColor;
  final double paddingTop;
  final double paddingBottom;
  final TextEditingController textEditingController;
  final int maxLines;
  bool validate;
  final bool autoFocus;
  final bool obscure;
  final bool autocorrect;
  final TextAlign textAlign;
  final RegExType regExType;

  PrimaryTextField(
      {Key key,
      this.initValue,
      this.focusNode,
      this.onFieldSubmitted,
      this.onSaved,
      this.labelText,
      this.helperText,
      this.helperStyle,
      this.labelStyle,
      this.style,
      this.textCapitalization,
      this.textInputAction,
      this.textInputType,
      this.cursorColor,
      this.paddingTop,
      this.paddingBottom,
      this.textEditingController,
      this.maxLines,
      this.hintText,
      this.validate,
      this.autoFocus,
      this.obscure,
      this.autocorrect,
      this.textAlign,
      this.regExType})
      : super(key: key);

  _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool showError = false;
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    widget.validate == null ? widget.validate = true : null;
    return Container(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 80),
      height: ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 10),
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.paddingTop ?? 0,
            bottom: widget.paddingBottom ?? padding * 2),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (showError)
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: padding * 2),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.pink,
                    child: Container(
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 5),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text(
                            errorMessage,
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.textFieldError,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 7.5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: padding * 4, right: padding * 4),
                  child: TextFormField(
                    autocorrect: widget.autocorrect ?? false,
                    obscureText: widget.obscure ?? false,
                    autofocus: widget.autoFocus ?? false,
                    controller: widget.textEditingController,
                    textCapitalization:
                        widget.textCapitalization ?? TextCapitalization.words,
                    initialValue: widget.textEditingController != null
                        ? null
                        : widget.initValue ?? "",
                    maxLines: widget.maxLines ?? 1,
                    textAlign: widget.textAlign ?? TextAlign.start,
                    focusNode: widget.focusNode,
                    textInputAction:
                        widget.textInputAction ?? TextInputAction.next,
                    cursorRadius: Radius.circular(1),
                    keyboardType: widget.textInputType ?? TextInputType.text,
                    cursorColor: widget.cursorColor ??
                        ServiceProvider
                            .instance.instanceStyleService.appStyle.skyBlue,
                    style: widget.style ??
                        ServiceProvider.instance.instanceStyleService.appStyle
                            .textFieldInput,
                    validator: widget.validate
                        ? (val) {
                            if (showError == true) showError = false;
                            String pattern;

                            if (val.length == 0) {
                              errorMessage = 'Vennligst fyll inn feltet';
                              showError = true;
                            } else {
                              switch (widget.regExType) {
                                case RegExType.phone:
                                  pattern = r"(^(?:[+0]9)?[0-9]{8,12}$)";
                                  errorMessage =
                                      'Vennligst fyll inn et gyldig mobilnummer';

                                  break;
                                case RegExType.email:
                                  pattern =
                                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                  errorMessage =
                                      'Vennligst fyll inn en gyldig email adresse';

                                  break;
                                default:
                              }
                              if (widget.regExType != null) {
                                RegExp regExp = new RegExp(pattern);
                                if (!regExp.hasMatch(val)) {
                                  showError = true;
                                }
                              }
                            }

                            setState(() {});
                            return null;
                          }
                        : null,
                    onSaved: (val) {
                      if (widget.textEditingController == null) {
                        if (!showError) widget.onSaved(val);
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (val) => widget.onFieldSubmitted(),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? null,
                      labelText: widget.labelText ?? null,
                      hintStyle: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                      helperText: widget.helperText ?? null,
                      helperStyle: widget.helperStyle ??
                          ServiceProvider
                              .instance.instanceStyleService.appStyle.italic,
                      labelStyle: widget.labelStyle ??
                          ServiceProvider.instance.instanceStyleService.appStyle
                              .body1Black,
                      counterStyle: TextStyle(
                          color: Colors.green, fontFamily: "Montserrat"),
                      enabledBorder:
                          new UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
