import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/provider/crud_provider.dart';

class JournalEventProvider extends CrudProvider {
  String path = "/eventItems";

  @override
  Future<List<JournalEventItem>> getCollection({String id}) {
    return super.getCollection(id: id + "/eventItems").then((qSnap) {
      List<JournalEventItem> list = <JournalEventItem>[];

      qSnap.documents.forEach((doc) {
        JournalEventItem journalEventItem = JournalEventItem.fromJson(doc.data);
        journalEventItem.docRef = doc.reference;
        list.add(journalEventItem);
      });

      return list;
    });
  }
}
