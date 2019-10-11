import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/textfield/primary_textfield.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';

class JournalAddCategoryController extends BaseController {
  double height;

  final List<JournalCategoryItem> journalCategoryItems;

  final String dogDocRefPath;

  JournalCategoryItem singleCategoryItem;

  final VoidCallback childOnSaved;

  final VoidCallback childOnDelete;

  PageState pageState;

  final _formKey = GlobalKey<FormState>();

  JournalAddCategoryController(
      {this.journalCategoryItems,
      this.childOnSaved,
      this.childOnDelete,
      this.dogDocRefPath,
      this.pageState,
      this.singleCategoryItem});

  PrimaryTextField addTextField;

  @override
  void initState() {
    if (singleCategoryItem == null)
      singleCategoryItem = JournalCategoryItem(
          title: "",
          journalEventItems: [],
          sortIndex: journalCategoryItems.length);
    addTextField = PrimaryTextField(
      initValue: singleCategoryItem.title,
      textCapitalization: TextCapitalization.sentences,
      validate: true,
      onSaved: (val) => singleCategoryItem.title = val,
      textInputType: TextInputType.text,
      textInputAction: TextInputAction.done,
      hintText: "Kategori-navn",
      onFieldSubmitted: () => onSaved(),
    );
    super.initState();
  }

  void onSaved() {
    _formKey.currentState.save();
    if (validateTextFields(singleTextField: addTextField)) {
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
    JournalProvider().delete(model: singleCategoryItem);
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

class JournalAddCategory extends BaseView {
  final JournalAddCategoryController controller;

  JournalAddCategory({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return LayoutBuilder(
      builder: (context, constraints) {
        controller.height = constraints.maxHeight;
        return Container(
          padding: EdgeInsets.all(getDefaultPadding(context) * 2),
          child: Form(
            key: controller._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: ServiceProvider
                              .instance.instanceStyleService.appStyle.textGrey,
                          size: ServiceProvider.instance.instanceStyleService
                              .appStyle.iconSizeBig,
                        ),
                      ),
                      Text(
                        controller.pageState == PageState.create
                            ? "Legg til ny"
                            : "Rediger",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.title,
                      ),
                      if (controller.pageState == PageState.create)
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: ServiceProvider.instance.instanceStyleService
                                .appStyle.iconSizeBig,
                            color: Colors.transparent,
                          ),
                          onPressed: () => null,
                        )
                      else
                        InkWell(
                          onTap: () => controller.onDelete(),
                          child: Icon(
                            Icons.delete,
                            size: ServiceProvider.instance.instanceStyleService
                                .appStyle.iconSizeBig,
                            color: controller.pageState == PageState.create
                                ? Colors.transparent
                                : ServiceProvider.instance.instanceStyleService
                                    .appStyle.textGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                controller.addTextField,
                PrimaryButton(
                  controller: PrimaryButtonController(
                    text: controller.pageState == PageState.create
                        ? "Legg til"
                        : "Bekreft",
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.green,
                    onPressed: () {
                      controller.onSaved();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
