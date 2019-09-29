import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/date_time_picker.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/user_provider.dart';

enum CreateOrUpdateDog { create, update }

class DogInfoController extends BaseController {
  final User user;

  final Dog dog;

  final CreateOrUpdateDog createOrUpdateDog;

  final void Function(Dog dog) onDone;

  final _formKey = GlobalKey<FormState>();

  final FocusScopeNode _node = FocusScopeNode();
  List<Widget> textFields;

  DogInfoController({this.onDone, this.user, this.dog, this.createOrUpdateDog});

  @override
  void initState() {
    if (dog.address == null) dog.address = Address();
    textFields = <Widget>[
      PrimaryTextField(
        initValue: dog?.name,
        onSaved: (val) => dog?.name = val.trim(),
        onFieldSubmitted: () => _node.nextFocus(),
        hintText: "Navn",
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        textInputType: TextInputType.text,
      ),
      PrimaryTextField(
        initValue: dog?.race,
        onSaved: (val) => dog?.race = val.trim(),
        onFieldSubmitted: () => _node.nextFocus(),
        hintText: "Rase",
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        textInputType: TextInputType.text,
      ),
      PrimaryTextField(
        initValue: dog?.weigth,
        onSaved: (val) => dog?.weigth = val.trim(),
        onFieldSubmitted: () => _node.nextFocus(),
        hintText: "Vekt",
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        textInputType: TextInputType.number,
      ),
      PrimaryTextField(
        initValue: dog?.address?.county,
        onSaved: (val) => dog?.address?.county = val.trim(),
        hintText: "Fylke",
        onFieldSubmitted: () => _node.nextFocus(),
        autocorrect: false,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
      ),
      PrimaryTextField(
        initValue: dog?.address?.city,
        onSaved: (val) => dog?.address?.city = val.trim(),
        hintText: "By",
        onFieldSubmitted: () => _node.nextFocus(),
        autocorrect: false,
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
      ),
      PrimaryTextField(
        initValue: dog?.address?.address,
        onSaved: (val) => dog?.address?.address = val.trim(),
        hintText: "Adresse",
        onFieldSubmitted: () => _node.unfocus(),
        autocorrect: false,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
      ),
      DateTimePicker(
        controller: DateTimePickerController(
            onConfirmed: (date) => dog?.birthDate = date,
            initialDate: dog?.birthDate,
            title: "Fødselsdato",
            label: "Fødselsdato"),
      ),
      PrimaryTextField(
        initValue: dog?.chipNumber,
        onSaved: (val) => dog?.chipNumber = val.trim(),
        onFieldSubmitted: () => _node.unfocus(),
        hintText: "Chip nummer (valgfritt)",
        validate: false,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.none,
        textInputType: TextInputType.number,
      ),
    ];
    super.initState();
  }
}

class DogInfo extends BaseView {
  final DogInfoController controller;

  DogInfo({this.controller});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller._formKey,
        child: FocusScope(
          node: controller._node,
          child: Column(
            children: <Widget>[
              Column(
                children: controller.textFields,
              ),
              PrimaryButton(
                controller: PrimaryButtonController(
                  text: "Bekreft ",
                  onPressed: () {
                    controller._formKey.currentState.save();
                    if (validateTextFields(textFields: controller.textFields)) {
                      controller.onDone(controller.dog);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
