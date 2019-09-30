import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/provider/crud_provider.dart';

Future<dynamic> handleCollectionItem(
    dynamic model, DocumentSnapshot doc, List<dynamic> list) {
  dynamic item = model.fromJson(doc.data);
  item.docRef = doc.reference;
  list.add(item);
  return item;
}

class DogProvider extends CrudProvider {
  Firestore firestoreInstance = Firestore.instance;
  @override
  Future create({model, String path}) {
    Firestore.instance
  }

  @override
  Future delete({model}) {
    return super.delete(model: model);
  }

  Future<List<JournalItem>> getJournalItems(String path) async {
    List<JournalItem> list = <JournalItem>[];
    QuerySnapshot qSnap = await firestoreInstance
        .collection(path + "/journalItems")
        .getDocuments();
    qSnap.documents.forEach((doc) {
      handleCollectionItem(JournalItem, doc, list);
    });
    return list;
  }

  @override
  Future<List<Dog>> getCollection({String path}) async {
    path += "/dogs";
    List<Dog> list = <Dog>[];
    QuerySnapshot qSnap =
        await firestoreInstance.collection(path).getDocuments();
    qSnap.documents.forEach((doc) async {
      Dog dog = await handleCollectionItem(Dog, doc, list);
      dog.journalItems = await getJournalItems(path);
    });
    return list;
  }

  @override
  Future read({String path}) {
    // TODO: implement read
    return null;
  }

  @override
  Future set({String path, model}) {
    // TODO: implement set
    return null;
  }

  @override
  Future update({model}) {
    return super.update(model: model);
  }
}
