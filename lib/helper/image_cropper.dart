import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:minhund/service/service_provider.dart';

class CustomImageCropper {
  Future<File> cropImage({Future<File> imageFile, bool circleShape}) async {
    File file = await imageFile;
    File croppedFile = await ImageCropper.cropImage(
      toolbarTitle: "Rediger bilde",

      toolbarWidgetColor:
          ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
      toolbarColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      statusBarColor:
          ServiceProvider.instance.instanceStyleService.appStyle.textGrey,

      circleShape: circleShape,
      sourcePath: file.path,
      ratioX: 1.0,
      ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 233, 242, 248), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor:
          Color.fromARGB(255, 233, 242, 248), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
    return croppedFile;
  }
}
