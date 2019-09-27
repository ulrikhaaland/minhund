import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';

class DogInfoController extends BaseController {
  final User user;

  final Dog dog;

  final VoidCallback onDone;

  final _formKey = GlobalKey<FormState>();

  final FocusScopeNode _node = FocusScopeNode();
  List<PrimaryTextField> textFields;

  DogInfoController({this.onDone, this.user, this.dog});
}

class DogInfo extends BaseView {
  final DogInfoController controller;

  DogInfo({this.controller});
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller._formKey,
      child: FocusScope(
        node: controller._node,
        child: Column(
          children: <Widget>[
            PrimaryTextField(
              initValue: controller.dog?.name,
              onSaved: (val) => controller.user.name = val.trim(),
              onFieldSubmitted: () => controller._node.nextFocus(),
              hintText: "Navn",
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.text,
            ),
            PrimaryTextField(
              initValue: controller.dog?.race,
              onSaved: (val) => controller.dog?.race = val.trim(),
              onFieldSubmitted: () => controller._node.nextFocus(),
              hintText: "Rase",
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.text,
            ),
            PrimaryTextField(
              initValue: controller.dog?.weigth,
              onSaved: (val) => controller.dog?.weigth = val.trim(),
              onFieldSubmitted: () => controller._node.nextFocus(),
              hintText: "Vekt",
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.number,
            ),
            DateTimePicker(
              controller: DateTimePickerController(
                  onConfirmed: (date) => controller.dog?.birthDate = date,
                  initialDate: controller.dog?.birthDate,
                  title: "Fødselsdato",
                  label: "Fødselsdato"),
            ),
            PrimaryButton(
              controller: PrimaryButtonController(
                text: "Bekreft ",
                onPressed: () {
                  controller._formKey.currentState.save();
                  if (validateTextFields(textFields: controller.textFields)) {
                    controller.onDone();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
