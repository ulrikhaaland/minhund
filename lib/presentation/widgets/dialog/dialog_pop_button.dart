import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';

class PopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.close,
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        size: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      ),
    );
  }
}
