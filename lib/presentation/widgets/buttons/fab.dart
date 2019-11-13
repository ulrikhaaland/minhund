import 'package:flutter/material.dart';
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


