import 'package:flutter/material.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';

class DogProfileController extends BaseController {
  final Dog dog;

  DogProfileController({this.dog});
}

class DogProfile extends BaseView {
  final DogProfileController controller;

  DogProfile({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return Column(
      children: <Widget>[],
    );
  }
}
