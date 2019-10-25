import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

import 'package:minhund/service/service_provider.dart';

class Fab extends StatelessWidget {
  final VoidCallback onPressed;

  const Fab({Key key, this.onPressed}) : super(key: key);
  @override
  FloatingActionButton build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.green,
      foregroundColor: Colors.white,
      child: Icon(Icons.add),
      onPressed: () => onPressed(),
    );
  }
}

// class FabController extends BaseController {
//   bool showFab;

//   final IconData iconData;

//   final VoidCallback onPressed;

//   FabController({this.iconData, this.showFab, this.onPressed});

//   void showFabAsMethod(bool show) {
//     showFab = show;
//     setState(() {});
//   }
// }

// class Fab extends BaseView {
//   final FabController controller;

//   Fab({this.controller});
//   @override
//   FloatingActionButton build(BuildContext context) {
//     if (!mounted) return null();
//     if (controller.showFab)
//       return FloatingActionButton(
//         backgroundColor:
//             ServiceProvider.instance.instanceStyleService.appStyle.green,
//         child: Icon(
//           controller.iconData ?? FontAwesomeIcons.solidComment,
//           color: Colors.white,
//           size: ServiceProvider
//               .instance.instanceStyleService.appStyle.iconSizeSmall,
//         ),
//         onPressed: () => controller.onPressed(),
//       );
//     return null();
//   }
// }
