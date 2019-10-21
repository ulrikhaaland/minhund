import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/presentation/home/journal/journal-category/journal_add_category.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'package:minhund/presentation/widgets/reorderable_list.dart';
import 'package:minhund/provider/journal_provider.dart';
import 'package:minhund/service/service_provider.dart';
import '../../../bottom_navigation.dart';
import 'journal-category/journal_category_list_item.dart';

class JournalPageController extends BottomNavigationController {
  final User user;

  Dog dog;

  static final JournalPageController _instance =
      JournalPageController._internal();

  factory JournalPageController() {
    print("Journal Page built");

    return _instance;
  }

  JournalPageController._internal({
    this.user,
  });

  // JournalPageController({
  //   this.user,
  // }) {
  //   print("Journal Page built");
  // }

  @override
  FloatingActionButton get fab => FloatingActionButton(
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => showCustomDialog(
          context: context,
          child: JournalAddCategory(
            controller: JournalAddCategoryController(
              journalCategoryItems: dog.journalItems,
              childOnSaved: () => refresh(),
              dogDocRefPath: dog.docRef.path,
              pageState: PageState.create,
            ),
          ),
        ),
      );

  @override
  String get title => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;

  @override
  Widget get bottomNav => null;

  @override
  void initState() {
    dog = user.dog;
    dog.profileImage.controller.imageSizePercentage = 5;

    super.initState();
  }
}

class JournalPage extends BottomNavigation {
  final JournalPageController controller;

  JournalPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.user.dog.profileImage == null) {
      controller.user.dog.profileImage = CustomImage(
        controller: CustomImageController(
          customImageType: CustomImageType.circle,
          imgUrl: controller.user.dog.imgUrl,
        ),
      );
    } else {
      controller.user.dog.profileImage.controller.init = false;
    }

    getTimeDifference(time: controller.dog.birthDate, daysMonthsYears: true);

    return SingleChildScrollView(
      child: Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 90),
        padding: EdgeInsets.only(
            left: getDefaultPadding(context) * 2,
            right: getDefaultPadding(context) * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 7.5 * 1.8),
                child: Card(
                  color: Colors.white,
                  elevation: ServiceProvider
                      .instance.instanceStyleService.appStyle.elevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ServiceProvider
                        .instance.instanceStyleService.appStyle.borderRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(getDefaultPadding(context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                controller.dog.name,
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${controller.dog.race}, ${getTimeDifference(time: controller.dog.birthDate, daysMonthsYears: true)}, ${controller.dog.weigth} kilo",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                        controller.user.dog.profileImage
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: getDefaultPadding(context) * 4,
            ),
            if (controller.dog.journalItems != null)
              Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 70),
                child: ReorderableList(
                    onReorder: (oldIndex, newIndex) {
                      JournalCategoryItem cItem =
                          controller.dog.journalItems.removeAt(oldIndex);

                      JournalCategoryItem oldItem = controller.dog.journalItems
                          .firstWhere((i) => i.sortIndex == newIndex,
                              orElse: () => null);

                      cItem.sortIndex = newIndex;

                      JournalProvider().update(model: cItem);

                      controller.dog.journalItems.insert(newIndex, cItem);

                      if (oldItem != null) {
                        oldItem.sortIndex =
                            controller.dog.journalItems.indexOf(oldItem);

                        JournalProvider().update(model: oldItem);
                      }
                    },
                    widgetList: controller.dog.journalItems
                        .map(
                          (item) => JournalCategoryListItem(
                            key: Key(item.id),
                            controller: JournalCategoryListItemController(
                                user: controller.user,
                                onUpdate: () => controller.setState(() {}),
                                dog: controller.dog,
                                item: item),
                          ),
                        )
                        .toList()),
              ),
          ],
        ),
      ),
    );
  }
}
