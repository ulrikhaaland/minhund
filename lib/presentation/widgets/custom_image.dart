import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/helper/image_cropper.dart';
import 'package:minhund/helper/image_picker.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/service/service_provider.dart';

import 'circular_progress_indicator.dart';

enum CustomImageType { circle, squared }

class CustomImageController extends BaseController {
  File imageFile;

  double imageSizePercentage;

  final CustomImageType customImageType;

  final String imgUrl;

  bool isLoading = false;

  final void Function(File file) getImageFile;

  bool init;

  CustomImageController(
      {this.imageSizePercentage,
      this.imageFile,
      this.customImageType,
      this.imgUrl,
      this.getImageFile,
      this.init = false});

  Future<void> getImage() async {
    try {
      setState(() => isLoading = true);
      imageFile =
          await CustomImageCropper().cropImage(FileProvider().getFile());
      if (imageFile != null) getImageFile(imageFile);
    } catch (e) {}
    setState(() => isLoading = false);
  }
}

class CustomImage extends BaseView {
  final CustomImageController controller;

  CustomImage({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    Widget icon;

    icon = Icon(
      Icons.add_a_photo,
      size: ServiceProvider.instance.instanceStyleService.appStyle.iconSizeBig,
      color: Colors.white,
    );

    switch (controller.customImageType) {
      case CustomImageType.circle:
        return Column(
          children: <Widget>[
            InkWell(
              onTap: () async => controller.init ? controller.getImage() : null,
              child: CircleAvatar(
                radius: ServiceProvider.instance.screenService
                    .getHeightByPercentage(
                        context, controller.imageSizePercentage ?? 7.5),
                backgroundColor: ServiceProvider
                    .instance.instanceStyleService.appStyle.green,
                child: controller.isLoading ? CPI(false) : icon,
                backgroundImage: controller.imgUrl != null
                    ? AdvancedNetworkImage(controller.imgUrl)
                    : controller.imageFile != null
                        ? FileImage(controller.imageFile)
                        : null,
              ),
            ),
            if (controller.init) ...[
              Container(
                height: getDefaultPadding(context),
              ),
              InkWell(
                onTap: () => controller.imageFile == null
                    ? controller.getImage()
                    : controller.setState(() => controller.imageFile = null),
                child: Text(
                  controller.imageFile == null
                      ? "Legg til et bilde av din hund"
                      : "Fjern bilde",
                  style: ServiceProvider.instance.instanceStyleService.appStyle
                      .disabledColoredText,
                ),
              ),
            ],
          ],
        );

        break;
      default:
    }
    return null;
  }
}
