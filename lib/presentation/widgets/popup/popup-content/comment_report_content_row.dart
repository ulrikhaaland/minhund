import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:minhund/service/service_provider.dart';

class DialogContentRow extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback onPressed;
  const DialogContentRow({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: InkWell(
        onTap: () => onPressed(),
        child: Container(
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 93),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 18),
                child: icon,
              ),
              Flexible(
                child: Container(
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 75),
                    child: Text(
                      text ?? "ISNULL",
                      style: ServiceProvider.instance.instanceStyleService
                          .appStyle.disabledColoredText,
                      overflow: TextOverflow.ellipsis,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class CommentReportContentRowController extends BaseController {
//   final Icon icon;
//   final Text text;
//   final VoidCallback onPressed;

//   CommentReportContentRowController({this.icon, this.text, this.onPressed});
// }

// class CommentReportContentRow extends BaseView {
//   final CommentReportContentRowController controller;

//   CommentReportContentRow({this.controller});
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => controller.onPressed(),
//       child: Row(
//         children: <Widget>[controller.icon, controller.text],
//       ),
//     );
//   }
// }
