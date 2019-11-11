import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/service/service_provider.dart';

class ExpandableCard extends StatefulWidget {
  final Color color;
  final bool expanded;
  final String title;

  final bool canExpand;

  final bool edit;

  final List<Widget> children;

  ExpandableCard(
      {Key key,
      this.color,
      this.children = const <Widget>[],
      this.title,
      this.canExpand = true,
      this.expanded = false,
      this.edit = false})
      : super(key: key);

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool expanded;

  @override
  void initState() {
    expanded = widget.expanded;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double padding = getDefaultPadding(context);

    return Padding(
      padding: EdgeInsets.only(top: padding * 2, bottom: padding * 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Material(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(20, 30))),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  color: widget.color ?? Colors.red,
                  borderRadius: BorderRadius.all(Radius.elliptical(20, 30))),
              width: constraints.maxWidth,
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 7.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.title,
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.descTitle
                                .copyWith(),
                          ),
                          if (widget.canExpand)
                            IconButton(
                              icon: Icon(expanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                              iconSize: ServiceProvider
                                  .instance
                                  .instanceStyleService
                                  .appStyle
                                  .iconSizeStandard,
                              onPressed: () =>
                                  setState(() => expanded = !expanded),
                            ),
                        ],
                      ),
                    ),
                    if (expanded)
                      Container(
                        decoration: BoxDecoration(
                            color: ServiceProvider.instance.instanceStyleService
                                .appStyle.dialogBackgroundColor,
                            border: Border.all(
                                color: ServiceProvider.instance
                                    .instanceStyleService.appStyle.leBleu),
                            borderRadius: BorderRadius.circular(ServiceProvider
                                .instance
                                .instanceStyleService
                                .appStyle
                                .borderRadius)),
                        child: Column(
                          children: widget.children,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
