import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    // return ReorderableListView(
    //   children: widget.widgetList,
    //   onReorder: _onReorder,
    // );

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
