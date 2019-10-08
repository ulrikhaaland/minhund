import 'package:minhund/model/journal_event_item.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/provider/crud_provider.dart';

class JournalEventProvider extends CrudProvider {
  String path = "/eventItems";
  @override
  Future update({model}) {
    return super.update(model: model);
  }

  @override
  Future get({String id}) {
    return super.get(id: id);
  }

  @override
  Future create({model, String id}) {
    return super.create(model: model, id: id + path);
  }

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

  @override
  Future delete({model}) {
    return super.delete(model: model);
  }

  @override
  Future set({String id, model}) {
    return super.set(id: id, model: model);
  }
}
