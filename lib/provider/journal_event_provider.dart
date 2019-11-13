import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/provider/crud_provider.dart';

class JournalEventProvider extends CrudProvider {
  String path = "/eventItems";

  @override
  Future<List<JournalEventItem>> getCollection({String id}) async {
    QuerySnapshot qSnap = await super.getCollection(id: id + "/eventItems");
    List<JournalEventItem> list = <JournalEventItem>[];

    if (qSnap.documents.isNotEmpty)
      for (DocumentSnapshot doc in qSnap.documents) {
        JournalEventItem journalEventItem = JournalEventItem.fromJson(doc.data);
        journalEventItem.docRef = doc.reference;
        list.add(journalEventItem);
      }

    return list;
  }
}
