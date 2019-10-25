import 'package:flutter/material.dart';

class TapToUnfocus extends StatelessWidget {
  final Widget child;

  final double width;

  const TapToUnfocus({Key key, this.child, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: width,
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
