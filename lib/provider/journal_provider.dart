import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/journal_category_item.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/journal_event_provider.dart';

class JournalProvider extends CrudProvider {
  String path = "/journalItems";

  @override
  Future create({model, String id}) {
    return super.create(model: model, id: id + path);
  }

  @override
  Future<List<JournalCategoryItem>> getCollection({String id}) async {
    QuerySnapshot qSnap = await super.getCollection(id: id + path);
    List<JournalCategoryItem> list = <JournalCategoryItem>[];

    qSnap.documents.forEach((doc) async {
      JournalCategoryItem journalItem = JournalCategoryItem.fromJson(doc.data);
      journalItem.docRef = doc.reference;
      list.add(journalItem);
    });

    return list;
  }
}
