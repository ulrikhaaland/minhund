import 'package:minhund/model/journal_item.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/journal_event_provider.dart';

class JournalProvider extends CrudProvider {
  String path = "/journalItems";
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
  Future<List<JournalItem>> getCollection({String id}) {
    return super.getCollection(id: id + path).then((qSnap) {
      List<JournalItem> list = <JournalItem>[];

      qSnap.documents.forEach((doc) async {
        JournalItem journalItem = JournalItem.fromJson(doc.data);
        journalItem.docRef = doc.reference;
        list.add(journalItem);
        journalItem.journalEventItems = await JournalEventProvider()
            .getCollection(id: id + path + "/${doc.documentID}");
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
