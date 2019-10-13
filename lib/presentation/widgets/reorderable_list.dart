import 'package:flutter/cupertino.dart';
import 'package:reorderables/reorderables.dart';

class ReorderableList<T> extends StatefulWidget {
  final List<T> widgetList;

  final void Function(int oldIndex, int newIndex) onReorder;

  const ReorderableList({Key key, this.widgetList, this.onReorder})
      : super(key: key);

  @override
  _ReorderableListState createState() => _ReorderableListState();
}

class _ReorderableListState<T> extends State<ReorderableList> {
  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      widget.onReorder(oldIndex, newIndex);
      setState(() {
        T row = widget.widgetList.removeAt(oldIndex);
        widget.widgetList.insert(newIndex, row);
      });
    }

    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        ReorderableSliverList(
          delegate: ReorderableSliverChildBuilderDelegate(
            (context, index) {
              return widget.widgetList[index];
            },
            childCount: widget.widgetList.length,
          ),
          onReorder: _onReorder,
        )
      ],
    );
  }
}

// class ReorderableListController<T> extends BaseController {
//   final List<T> widgetList;

//   final void Function(int oldIndex, int newIndex) onReorder;

//   ReorderableListController({this.widgetList, this.onReorder});

//   @override
//   void initState() {
//     super.initState();
//   }
// }

// class ReorderableList<T> extends BaseView {
//   final ReorderableListController controller;

//   ReorderableList({this.controller});
//   @override
//   Widget build(BuildContext context) {
//     void _onReorder(int oldIndex, int newIndex) {
//       controller.setState(() {
//         T row = controller.widgetList.removeAt(oldIndex);
//         controller.widgetList.insert(newIndex, row);
//       });
//     }

//     // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
//     // Otherwise an error will be thrown.
//     ScrollController _scrollController =
//         PrimaryScrollController.of(context) ?? ScrollController();

//     return CustomScrollView(
//       // A ScrollController must be included in CustomScrollView, otherwise
//       // ReorderableSliverList wouldn't work
//       controller: _scrollController,
//       slivers: <Widget>[
//         ReorderableSliverList(
//           delegate: ReorderableSliverChildBuilderDelegate(
//             (context, index) {
//               return controller.widgetList[index];
//             },
//             childCount: controller.widgetList.length,
//           ),
//           // or use ReorderableSliverChildBuilderDelegate if needed
// //          delegate: ReorderableSliverChildBuilderDelegate(
// //            (BuildContext context, int index) => _rows[index],
// //            childCount: _rows.length
// //          ),
//           onReorder: _onReorder,
//         )
//       ],
//     );
//   }
// }
