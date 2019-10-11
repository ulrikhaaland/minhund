import 'package:flutter/material.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/home/journal/journal-event/journal_event_page.dart';
import 'package:minhund/service/service_provider.dart';

class JournalCategoryListItemController extends BaseController {
  final JournalCategoryItem item;

  final Dog dog;

  final VoidCallback onUpdate;

  JournalCategoryListItemController({this.item, this.dog, this.onUpdate});

  @override
  void initState() {
    if (item.journalEventItems == null) item.journalEventItems = [];
    super.initState();
  }
}

class JournalCategoryListItem extends BaseView {
  final JournalCategoryListItemController controller;

  final Key key;

  JournalCategoryListItem({this.controller, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return LayoutBuilder(
      builder: (context, con) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalEventPage(
                  controller: JournalEventPageController(
                    categoryItem: controller.item,
                    dog: controller.dog,
                    onUpdate: (refreshParent) {
                      if (refreshParent) {
                        controller.onUpdate();
                      } else {
                        controller.setState(() {});
                      }
                    },
                  ),
                ),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        controller.item.title,
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.smallTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        controller.item.journalEventItems.length == 0
                            ? ""
                            : controller.item.journalEventItems.length
                                    .toString() ??
                                "",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
