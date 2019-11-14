import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/widgets/buttons/save_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/tap_to_unfocus.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/cloud_functions_provider.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/color_picker.dart';

class JournalAddCategoryController extends DialogTemplateController {
  double height;

  final List<JournalCategoryItem> journalCategoryItems;

  final String dogDocRefPath;

  JournalCategoryItem singleCategoryItem;

  final VoidCallback childOnSaved;

  final VoidCallback childOnDelete;

  PageState pageState;

  bool canSave = false;

  SaveButtonController saveBtnCtrlr;

  JournalAddCategoryController(
      {this.journalCategoryItems,
      this.childOnSaved,
      this.childOnDelete,
      this.dogDocRefPath,
      this.pageState,
      this.singleCategoryItem});

  @override
  Widget get actionOne => PopButton();

  @override
  Widget get actionTwo => SaveButton(
        controller: saveBtnCtrlr,
      );

  @override
  String get title => pageState == PageState.create ? "Ny kategori" : "Rediger";

  @override
  void initState() {
    if (singleCategoryItem == null)
      singleCategoryItem = JournalCategoryItem(
          title: "",
          journalEventItems: [],
          sortIndex: journalCategoryItems.length,
          colorIndex: 1);

    if (singleCategoryItem.title.length > 0) canSave = true;

    saveBtnCtrlr = SaveButtonController(
      onPressed: () => onSaved(),
      canSave: canSave,
    );
    super.initState();
  }

  Future<void> onSaved() async {
    if (canSave) {
      if (pageState == PageState.create) {
        journalCategoryItems.add(singleCategoryItem);
        await JournalProvider()
            .create(model: singleCategoryItem, id: dogDocRefPath);
      } else {
        JournalProvider().update(model: singleCategoryItem);
      }

      childOnSaved();
      Navigator.pop(context);
    }
  }

  void onDelete() {
    //  Parent deletes from list
    String pathFromDog = singleCategoryItem.docRef.path.split("dogs")[1];

    CloudFunctionsProvider().recursiveUserSpecificDelete(
        pathAfterTypeId: "dogs$pathFromDog", userType: UserType.user);

    childOnDelete();
  }

  Widget basicContainer({Widget child, double width}) {
    return Container(
      alignment: Alignment.center,
      height: height * 0.1,
      width: width != null ? (width * 0.935) / 2 : null,
      child: child,
    );
  }
}

class JournalAddCategory extends DialogTemplate {
  final JournalAddCategoryController controller;

  JournalAddCategory({this.controller});

  @override
  Widget buildDialogContent(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return TapToUnfocus(
      child: LayoutBuilder(
        builder: (context, constraints) {
          controller.height = constraints.maxHeight;
          return Container(
            padding: EdgeInsets.all(padding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PrimaryTextField(
                  asListTile: true,
                  autoFocus: controller.pageState == PageState.create,
                  initValue: controller.singleCategoryItem.title,
                  textCapitalization: TextCapitalization.sentences,
                  textFieldType: TextFieldType.ordinary,
                  onChanged: (val) {
                    if (val.length > 0)
                      controller.canSave = true;
                    else
                      controller.canSave = false;
                    controller.singleCategoryItem.title = val;
                    controller.setState(() {
                      controller.saveBtnCtrlr.canSave = controller.canSave;
                    });
                  },
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  hintText: "Navn",
                  onFieldSubmitted: () => controller.onSaved(),
                ),
                ColorPicker(
                  controller: ColorPickerController(
                    onChanged: (index) =>
                        controller.singleCategoryItem.colorIndex = index,
                    initIndex: controller.singleCategoryItem.colorIndex ?? 0,
                  ),
                ),
                if (controller.pageState == PageState.edit) ...[
                  Container(
                    height: padding * 6,
                  ),
                  Center(
                    child: SecondaryButton(
                      text: "Slett kategori",
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.pink,
                      onPressed: () => controller.onDelete(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
