import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_save_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_template.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/cloud_functions_provider.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';

class JournalAddCategoryController extends DialogTemplateController {
  double height;

  final List<JournalCategoryItem> journalCategoryItems;

  final String dogDocRefPath;

  JournalCategoryItem singleCategoryItem;

  final VoidCallback childOnSaved;

  final VoidCallback childOnDelete;

  PageState pageState;

  bool canSave = false;

  DialogSaveButtonController saveBtnCtrlr;

  JournalAddCategoryController(
      {this.journalCategoryItems,
      this.childOnSaved,
      this.childOnDelete,
      this.dogDocRefPath,
      this.pageState,
      this.singleCategoryItem});

  @override
  // TODO: implement actionOne
  Widget get actionOne => PopButton();

  @override
  // TODO: implement actionTwo
  Widget get actionTwo => DialogSaveButton(
        controller: saveBtnCtrlr,
      );

  @override
  // TODO: implement title
  String get title => pageState == PageState.create ? "Legg til ny" : "Rediger";

  @override
  void initState() {
    if (singleCategoryItem == null)
      singleCategoryItem = JournalCategoryItem(
          title: "",
          journalEventItems: [],
          sortIndex: journalCategoryItems.length);

    if (singleCategoryItem.title.length > 0) canSave = true;

    saveBtnCtrlr = DialogSaveButtonController(
      onPressed: () => onSaved(),
      canSave: canSave,
    );
    super.initState();
  }

  void onSaved() {
    if (canSave) {
      if (pageState == PageState.create) {
        journalCategoryItems.add(singleCategoryItem);
        JournalProvider().create(model: singleCategoryItem, id: dogDocRefPath);
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
    print(pathFromDog);
    CloudFunctionsProvider().recursiveDelete("dogs$pathFromDog");
    // JournalProvider().delete(model: singleCategoryItem);
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            controller.height = constraints.maxHeight;
            return Container(
              padding: EdgeInsets.all(getDefaultPadding(context) * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PrimaryTextField(
                    autoFocus: true,
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
                    hintText: "Kategori-navn",
                    onFieldSubmitted: () => controller.onSaved(),
                  ),
                  if (controller.pageState == PageState.edit)
                    SecondaryButton(
                      topPadding: 0,
                      text: "Slett",
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.pink,
                      onPressed: () => controller.onDelete(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
