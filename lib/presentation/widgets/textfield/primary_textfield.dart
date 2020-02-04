import 'package:minhund/helper/helper.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';

enum RegExType { phone, email, password, smsCode }

enum TextFieldType { form, ordinary }

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
  final double maxLines;
  bool validate;
  final bool autoFocus;
  final bool obscure;
  final bool autocorrect;
  final TextAlign textAlign;
  final RegExType regExType;
  final int maxLength;
  final double width;
  final TextFieldType textFieldType;
  final bool asListTile;
  final String prefixText;
  final bool enabled;

  final void Function(String val) onChanged;

  bool canSave;

  PrimaryTextField({
    Key key,
    this.initValue,
    this.focusNode,
    this.enabled = true,
    this.onFieldSubmitted,
    this.onSaved,
    this.prefixText,
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
    this.maxLines = 1,
    this.hintText,
    this.validate = false,
    this.autoFocus,
    this.obscure,
    this.autocorrect,
    this.textAlign,
    this.regExType,
    this.maxLength,
    this.onChanged,
    this.width,
    this.textFieldType,
    this.asListTile = false,
    this.canSave = true,
  }) : super(key: key);

  _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;

  TextEditingController textEditingController = TextEditingController();

  @override
  initState() {
    textEditingController.text = widget.initValue ?? "";
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  dispose() {
    textEditingController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    double padding = getDefaultPadding(context);

    widget.validate == null ? widget.validate = true : null;
    Widget textField = Container(
      width: widget.width ??
          ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 80),
      height: !widget.canSave
          ? ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 12.5)
          : null,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.paddingTop ?? 0,
            bottom: widget.paddingBottom ?? padding * 2),
        child: Stack(
          children: <Widget>[
            if (!widget.canSave)
              Positioned(
                bottom: 0,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0.0, -0.70), end: Offset.zero)
                      .animate(CurvedAnimation(
                          curve: Curves.decelerate, parent: _animController)),
                  child: Padding(
                    padding: EdgeInsets.only(left: padding * 2),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ServiceProvider
                            .instance
                            .instanceStyleService
                            .appStyle
                            .borderRadius),
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
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.textFieldError,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(
                      context, widget.maxLines > 1 ? 15 : 7.5),
              // child: Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(ServiceProvider
              //         .instance.instanceStyleService.appStyle.borderRadius),
              //     boxShadow: <BoxShadow>[
              //       BoxShadow(
              //         color: ServiceProvider.instance.instanceStyleService.appStyle.imperial.withOpacity(0.1),
              //         blurRadius: 1,
              //         offset: Offset(0, 2),
              //       ),
              //     ],
              //   ),
                child: Card(
                  elevation: widget.enabled ? 1 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ServiceProvider
                        .instance.instanceStyleService.appStyle.borderRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: padding * 4,
                        right: padding * 4,
                        bottom: widget.prefixText == null ? padding * 2 : 0),
                    child: Center(
                      child: widget.textFieldType == TextFieldType.ordinary
                          ? TextField(
                              enabled: widget.enabled ?? true,
                              autocorrect: widget.autocorrect ?? false,
                              obscureText: widget.obscure ?? false,
                              autofocus: widget.autoFocus ?? false,
                              controller: widget.textEditingController ??
                                  textEditingController,
                              textCapitalization: widget.textCapitalization ??
                                  TextCapitalization.sentences,
                              maxLines: widget.maxLines?.toInt() ?? 1,
                              textAlign: widget.textAlign ?? TextAlign.start,
                              focusNode: widget.focusNode,
                              textInputAction: widget.textInputAction ??
                                  TextInputAction.next,
                              cursorRadius: Radius.circular(1),
                              keyboardType:
                                  widget.textInputType ?? TextInputType.text,
                              cursorColor: widget.cursorColor ??
                                  ServiceProvider.instance.instanceStyleService
                                      .appStyle.skyBlue,
                              style: widget.style ??
                                  ServiceProvider.instance.instanceStyleService
                                      .appStyle.textFieldInput,
                              onChanged: (val) => widget.onChanged(val),
                              onSubmitted: (val) => widget.onFieldSubmitted(),
                              decoration: InputDecoration(
                                prefixText: widget.prefixText,
                                prefixStyle: widget.style ??
                                    ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .textFieldInput,
                                hintText: !widget.asListTile
                                    ? widget.hintText ?? null
                                    : null,
                                labelText: widget.labelText ?? null,
                                hintStyle: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                helperText: widget.helperText ?? null,
                                helperStyle: widget.helperStyle ??
                                    ServiceProvider.instance
                                        .instanceStyleService.appStyle.italic,
                                labelStyle: widget.labelStyle ??
                                    ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .body1Black,
                                counterStyle: TextStyle(
                                    color: Colors.green,
                                    fontFamily: "Montserrat"),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                disabledBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : TextFormField(
                              enabled: widget.enabled ?? true,
                              autocorrect: widget.autocorrect ?? false,
                              obscureText: widget.obscure ?? false,
                              autofocus: widget.autoFocus ?? false,
                              controller: widget.textEditingController ??
                                  textEditingController,
                              textCapitalization: widget.textCapitalization ??
                                  TextCapitalization.sentences,
                              maxLines: widget.maxLines?.toInt() ?? 1,
                              textAlign: widget.textAlign ?? TextAlign.start,
                              focusNode: widget.focusNode,
                              textInputAction: widget.textInputAction ??
                                  TextInputAction.next,
                              cursorRadius: Radius.circular(1),
                              keyboardType:
                                  widget.textInputType ?? TextInputType.text,
                              cursorColor: widget.cursorColor ??
                                  ServiceProvider.instance.instanceStyleService
                                      .appStyle.skyBlue,
                              style: widget.style ??
                                  ServiceProvider.instance.instanceStyleService
                                      .appStyle.textFieldInput,
                              onSaved: (val) {
                                val = val.trim();

                                if (widget.validate == true ||
                                    widget.validate == null) {
                                  if (widget.canSave == false)
                                    widget.canSave = true;

                                  String pattern;

                                  if (val.length == 0 && widget.validate) {
                                    errorMessage = 'Vennligst fyll inn feltet';
                                    widget.canSave = false;
                                  } else {
                                    switch (widget.regExType) {
                                      case RegExType.phone:
                                        pattern =
                                            r"(^(?:[+][0-9]{1,4})?[0-9]{8,12}$)";
                                        errorMessage =
                                            'Vennligst fyll inn et gyldig mobilnummer';

                                        break;
                                      case RegExType.email:
                                        pattern =
                                            r"^[a-zA-Z0-9-_.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                        errorMessage =
                                            'Vennligst fyll inn en gyldig email adresse';

                                        break;
                                      case RegExType.smsCode:
                                        if (val.length < 6) {
                                          errorMessage =
                                              "Vennligst fyll inn din 6-sifrede kode";
                                          widget.canSave = false;
                                        }
                                        break;
                                      case RegExType.password:
                                        if (val.length < 8) {
                                          errorMessage =
                                              "Passordet må minst være 8 sifre langt";
                                          widget.canSave = false;
                                        }
                                        break;
                                      default:
                                    }
                                    if (widget.regExType != null &&
                                        pattern != null) {
                                      RegExp regExp = new RegExp(pattern);
                                      if (!regExp.hasMatch(val)) {
                                        widget.canSave = false;
                                      }
                                    }
                                  }

                                  setState(() {
                                    _animController.forward();
                                  });
                                }
                                if (widget.textEditingController == null) {
                                  if (widget.canSave) widget.onSaved(val);
                                } else {
                                  return null;
                                }
                              },
                              onFieldSubmitted: (val) =>
                                  widget.onFieldSubmitted(),
                              decoration: InputDecoration(
                                prefixText: widget.prefixText,
                                prefixStyle: widget.style ??
                                    ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .textFieldInput
                                        .copyWith(
                                            color: ServiceProvider
                                                .instance
                                                .instanceStyleService
                                                .appStyle
                                                .textGrey),
                                hintText: !widget.asListTile
                                    ? widget.hintText ?? null
                                    : null,
                                labelText: widget.labelText ?? null,
                                hintStyle: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                helperText: widget.helperText ?? null,
                                helperStyle: widget.helperStyle ??
                                    ServiceProvider.instance
                                        .instanceStyleService.appStyle.italic,
                                labelStyle: widget.labelStyle ??
                                    ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .body1Black,
                                counterStyle: TextStyle(
                                    color: Colors.green,
                                    fontFamily: "Montserrat"),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                disabledBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            // ),
          ],
        ),
      ),
    );

    if (widget.asListTile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: padding, bottom: padding),
            child: Text(
              widget.hintText,
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.body1,
            ),
          ),
          textField,
        ],
      );
    }
    return textField;
  }
}
