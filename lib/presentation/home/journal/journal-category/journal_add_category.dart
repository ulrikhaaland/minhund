import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/home/journal/journal_page.dart';
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

abstract class CategoryActionController {
  Future<void> onCategoryDelete({JournalCategoryItem category});
  Future<void> onCategoryUpdate({JournalCategoryItem category});
  Future<void> onCategoryCreate({JournalCategoryItem category});
}

class JournalAddCategoryController extends DialogTemplateController
    implements CategoryActionController {
  double height;

  final JournalPageController actionController;

  JournalCategoryItem singleCategoryItem;

  PageState pageState;

  String categoryTitle;

  int categoryColorIndex = 4;

  bool canSave = false;

  SaveButtonController saveBtnCtrlr;

  JournalAddCategoryController(
      {this.actionController, this.pageState, this.singleCategoryItem});

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
          sortIndex: actionController.dog.journalItems.length,
          colorIndex: 1);
    else {
      categoryTitle = singleCategoryItem.title;
      categoryColorIndex = singleCategoryItem.colorIndex;
    }
    if (singleCategoryItem.title.length > 0) canSave = true;

    saveBtnCtrlr = SaveButtonController(
      onPressed: () => onSaved(),
      canSave: canSave,
    );
    super.initState();
  }

  Future<void> onSaved() async {
    if (canSave) {
      singleCategoryItem.title = categoryTitle;
      singleCategoryItem.colorIndex = categoryColorIndex;
      if (pageState == PageState.create) {
        onCategoryCreate(category: singleCategoryItem);
      } else {
        onCategoryUpdate(category: singleCategoryItem);
      }

      // Navigator.pop(context);
    }
  }

  Widget basicContainer({Widget child, double width}) {
    return Container(
      alignment: Alignment.center,
      height: height * 0.1,
      width: width != null ? (width * 0.935) / 2 : null,
      child: child,
    );
  }

  @override
  Future<void> onCategoryCreate({JournalCategoryItem category}) {
    return actionController.onCategoryCreate(category: category);
  }

  @override
  Future<void> onCategoryDelete({JournalCategoryItem category}) {
    Navigator.of(context)..pop()..pop();
    return actionController.onCategoryDelete(category: category);
  }

  @override
  Future<void> onCategoryUpdate({JournalCategoryItem category}) {
    return actionController.onCategoryUpdate(category: category);
  }

  @override
  bool get withBorder => false;
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
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PrimaryTextField(
                  asListTile: true,
                  autoFocus: controller.pageState == PageState.create,
                  initValue: controller.categoryTitle,
                  textCapitalization: TextCapitalization.sentences,
                  textFieldType: TextFieldType.ordinary,
                  onChanged: (val) {
                    if (val.length > 0) {
                      controller.canSave = true;
                      controller.categoryTitle = val;
                    } else
                      controller.canSave = false;

                    controller.setState(() {
                      controller.saveBtnCtrlr.canSave = controller.canSave;
                    });
                  },
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  hintText: "Navn",
                  onFieldSubmitted: () => controller.onSaved(),
                ),
                Divider(),
                Container(
                  height: padding * 2,
                ),
                ColorPicker(
                  controller: ColorPickerController(
                    onChanged: (index) => controller.categoryColorIndex = index,
                    initIndex: controller.categoryColorIndex ?? 0,
                  ),
                ),
                if (controller.pageState == PageState.edit) ...[
                  Container(
                    height: padding * 2,
                  ),
                  Divider(),
                  Container(
                    height: padding * 6,
                  ),
                  Center(
                    child: SecondaryButton(
                      text: "Slett kategori",
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.pink,
                      onPressed: () => controller.onCategoryDelete(
                          category: controller.singleCategoryItem),
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
