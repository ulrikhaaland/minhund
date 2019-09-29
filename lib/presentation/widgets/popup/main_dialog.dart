// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:minhund/model/report_dialog_info.dart';
// import 'package:minhund/presentation/base_controller.dart';
// import 'package:minhund/presentation/base_view.dart';
// import 'package:minhund/presentation/widgets/popup/popup-content/comment_report_content_row.dart';
// import 'package:minhund/provider/user_provider.dart';
// import 'package:minhund/service/service_provider.dart';
// import 'package:provider/provider.dart';

// enum DialogContentType { report, undefined, isOwner }

// class MainDialogController extends BaseController {
//   final ReportDialogInfo reportDialogInfo;

//   final List<Widget> bar;
//   final Widget barStart;
//   final Widget barEnd;
//   List<Widget> body;
//   final bool divide;
//   final DialogContentType dialogContentType;
//   final VoidCallback onDeleteComment;

//   MainDialogController(
//       {this.reportDialogInfo,
//       this.bar,
//       this.onDeleteComment,
//       this.body,
//       this.divide,
//       this.barEnd,
//       this.barStart,
//       this.dialogContentType});

//   @override
//   void initState() {
//     super.initState();
//   }

//   List<Widget> getDialogBody() {
//     switch (dialogContentType) {
//       case DialogContentType.report:
//         return [
//           DialogContentRow(
//             onPressed: () {
//               if (reportDialogInfo.reportedUser.blocked) {
//                 reportDialogInfo.reportedByUser.blockedUserIds
//                     .remove(reportDialogInfo.reportedUser.id);
//               } else {
//                 reportDialogInfo.reportedByUser.blockedUserIds
//                     .add(reportDialogInfo.reportedUser.id);
//               }
//               UserProvider().update(reportDialogInfo.reportedByUser);
//               Navigator.pop(context);
//             },
//             text: reportDialogInfo.reportedUser.blocked
//                 ? "Fjern blokkering av ${reportDialogInfo.reportedUser.userName ?? "N/A"} "
//                 : "Blokker ${reportDialogInfo.reportedUser.userName ?? "N/A"}",
//             icon: Icon(
//               FontAwesomeIcons.ban,
//               color: ServiceProvider
//                   .instance.instanceStyleService.appStyle.textGrey,
//               size: ServiceProvider
//                   .instance.instanceStyleService.appStyle.iconSizeStandard,
//             ),
//           ),
//           DialogContentRow(
//             onPressed: () {
//               reportDialogInfo.pushReport();
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               FontAwesomeIcons.solidFlag,
//               color: ServiceProvider
//                   .instance.instanceStyleService.appStyle.textGrey,
//               size: ServiceProvider
//                   .instance.instanceStyleService.appStyle.iconSizeStandard,
//             ),
//             text: reportDialogInfo.typeString == "post"
//                 ? "Rapporter innlegg"
//                 : "Rapporter kommentar",
//           )
//         ];

//         break;

//       case DialogContentType.isOwner:
//         {
//           return [
//             DialogContentRow(
//               onPressed: () {
//                 onDeleteComment();
//               },
//               icon: Icon(
//                 FontAwesomeIcons.trash,
//                 size: ServiceProvider
//                     .instance.instanceStyleService.appStyle.iconSizeStandard,
//                 color: ServiceProvider
//                     .instance.instanceStyleService.appStyle.textGrey,
//               ),
//               text: "Slett kommentar",
//             ),
//           ];
//         }
//         break;

//       case DialogContentType.undefined:
//         {
//           if (body == null) {
//             return [];
//           }
//         }

//         break;
//       default:
//         return [];
//     }
//   }
// }

// class MainDialog extends BaseView {
//   final MainDialogController controller;

//   MainDialog({this.controller});
//   @override
//   Widget build(BuildContext context) {
//     controller.reportDialogInfo.reportedUser.blocked = controller
//         .reportDialogInfo.reportedByUser.blockedUserIds
//         .contains(controller.reportDialogInfo.reportedUser.id);

//     if (controller.body == null) {
//       controller.body = controller.getDialogBody();
//       controller.body.add(Container(
//         height: 12,
//       ));
//     }

//     return Container(
//       width: ServiceProvider.instance.screenService
//           .getWidthByPercentage(context, 100),
//       child: IntrinsicHeight(
//         child: Container(
//           padding: EdgeInsets.only(bottom: 12, top: 12),
//           width: ServiceProvider.instance.screenService
//               .getWidthByPercentage(context, 93),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 children: controller.bar != null
//                     ? controller.bar
//                     : <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             controller.barStart != null
//                                 ? controller.barStart
//                                 : Container(
//                                     height: ServiceProvider
//                                         .instance.screenService
//                                         .getHeightByPercentage(context, 5),
//                                     width: ServiceProvider
//                                         .instance.screenService
//                                         .getWidthByPercentage(context, 18),
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       child: InkWell(
//                                         onTap: () => Navigator.pop(context),
//                                         child: Icon(
//                                           FontAwesomeIcons.solidTimesCircle,
//                                           color: ServiceProvider
//                                               .instance
//                                               .instanceStyleService
//                                               .appStyle
//                                               .imperial,
//                                           size: ServiceProvider
//                                               .instance
//                                               .instanceStyleService
//                                               .appStyle
//                                               .iconSizeStandard,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                             Container(
//                               padding: EdgeInsets.only(right: 18),
//                               height: ServiceProvider.instance.screenService
//                                   .getHeightByPercentage(context, 5),
//                               width: ServiceProvider.instance.screenService
//                                   .getWidthByPercentage(context, 75),
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: controller.barEnd != null
//                                     ? controller.barEnd
//                                     : Icon(
//                                         FontAwesomeIcons.reply,
//                                         color: Colors.transparent,
//                                         size: ServiceProvider
//                                             .instance
//                                             .instanceStyleService
//                                             .appStyle
//                                             .iconSizeStandard,
//                                       ),
//                               ),
//                             )
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 12.0, bottom: 6),
//                           child: Container(
//                             height: 0.5,
//                             width: ServiceProvider.instance.screenService
//                                 .getWidthByPercentage(context, 93),
//                             color: ServiceProvider.instance.instanceStyleService
//                                 .appStyle.textGrey,
//                           ),
//                         ),
//                         Column(
//                           children: controller.body != null
//                               ? controller.body
//                               : [Container()],
//                         )
//                       ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
