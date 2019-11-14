import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

class ColorAndPicked {
  final Color color;
  bool picked;

  ColorAndPicked({this.color, this.picked});
}

class ColorPickerController extends BaseController {
  final void Function(int index) onChanged;

  List<ColorAndPicked> colors;

  List<Color> palette;

  final int initIndex;

  ColorPickerController({this.onChanged, this.initIndex});

  @override
  void initState() {
    palette = ServiceProvider.instance.instanceStyleService.appStyle.palette;

    colors = [
      ColorAndPicked(color: palette[0], picked: false),
      ColorAndPicked(color: palette[1], picked: false),
      ColorAndPicked(color: palette[2], picked: false),
      ColorAndPicked(color: palette[3], picked: false),
      ColorAndPicked(color: palette[4], picked: false),
      ColorAndPicked(color: palette[5], picked: false),
    ];

    colors[initIndex].picked = true;

    super.initState();
  }

  void pickColor({ColorAndPicked pick}) {
    setState(() {
      colors.firstWhere((c) => c.picked == true).picked = false;
      pick.picked = true;
    });
    onChanged(colors.indexOf(pick));
  }
}

class ColorPicker extends BaseView {
  final ColorPickerController controller;

  ColorPicker({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);
    return Padding(
      padding: EdgeInsets.only(left: padding * 2, right: padding * 2),
      child: LayoutBuilder(
        builder: (context, con) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Container(
                height: padding * 2,
              ),
              Text(
                "Farge",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.body1,
              ),
              Container(
                height: padding * 2,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: controller.colors
                      .map(
                        (cp) => GestureDetector(
                          onTap: () => controller.pickColor(pick: cp),
                          child: CircleAvatar(
                            backgroundColor: cp.color,
                            radius: con.maxWidth / 14,
                            child: cp.picked
                                ? Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        ),
                      )
                      .toList()),
            ],
          );
        },
      ),
    );
  }
}
