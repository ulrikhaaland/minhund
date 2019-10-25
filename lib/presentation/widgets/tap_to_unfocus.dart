import 'package:flutter/material.dart';

class TapToUnfocus extends StatelessWidget {
  final Widget child;

  const TapToUnfocus({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
