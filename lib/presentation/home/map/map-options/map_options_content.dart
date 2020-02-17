import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/map_options.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/service/service_provider.dart';

class MapOptionsContent extends StatefulWidget {
  final MapOptions mapOptions;

  final void Function(PlaceCategory placeCategory) onCheckboxAction;
  MapOptionsContent({Key key, this.mapOptions, this.onCheckboxAction})
      : super(key: key);

  @override
  _MapOptionsContentState createState() => _MapOptionsContentState();
}

class _MapOptionsContentState extends State<MapOptionsContent> {
  @override
  Widget build(BuildContext context) {
    double padding = getDefaultPadding(context);

    return Padding(
      padding: EdgeInsets.all(getDefaultPadding(context) * 2),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PopButton(),
                Flexible(
                  child: Text(
                    "Alternativer",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.smallTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.close,
                  color: Colors.transparent,
                  size: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeStandard,
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            ...widget.mapOptions.placeCategories.asMap().entries.map((cat) {
              return CheckboxListTile(
                title: Text(
                  cat.value.name ?? "Ikke kategorisert",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.smallTitle,
                ),
                value: cat.value.selected,
                onChanged: (val) => setState(() {
                  cat.value.selected = val;
                  widget.onCheckboxAction(cat.value);
                }),
                checkColor: Colors.white,
                activeColor: ServiceProvider.instance.instanceStyleService
                    .appStyle.palette[cat.value.colorIndex],
              );
            }),
          ],
        ),
      ),
    );
  }
}
