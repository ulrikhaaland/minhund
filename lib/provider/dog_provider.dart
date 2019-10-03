import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/journal_item.dart';
import 'package:minhund/provider/crud_provider.dart';

class DogProvider extends CrudProvider {
  Firestore firestoreInstance = Firestore.instance;

  Dog dog;

  @override
  Future<DocumentReference> create({dynamic model, String id}) {
    String path = "users/$id/dogs";
    return super.create(model: model, id: path).then((docRef) {
      if (model.journalItems.isNotEmpty) {
        model.journalItems.forEach((item) {
          firestoreInstance
              .collection(path + "/${model.id}/journalItems")
              .add(item.toJson());
        });
      }
      return docRef;
    });
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
      JournalItem journalItem = JournalItem.fromJson(doc.data);
      journalItem.docRef = doc.reference;
      list.add(journalItem);
    });
    return list;
  }

  @override
  Future<List<Dog>> getCollection({String id}) async {
    List<Dog> list = [];
    String path = "users/$id/dogs";
    return super.getCollection(id: path).then((qSnap) {
      if (qSnap.documents.isNotEmpty) {
        qSnap.documents.forEach((doc) async {
          Dog dog = Dog.fromJson(doc.data);
          dog.docRef = doc.reference;
          list.add(dog);
          dog.journalItems = await getJournalItems(path + "/${doc.documentID}");
        });
      }
      return list;
    });
  }

  @override
  Future<Dog> get({String id}) {
    return super.get(id: id).then((docSnap) {
      Dog dog = Dog.fromJson(docSnap.data);
      dog.docRef = docSnap.reference;
      dog.id = docSnap.documentID;
      return dog;
    });
  }

  @override
  Future set({String id, dynamic model}) {
    return super.set(id: id, model: model);
  }

  @override
  Future update({model}) {
    return super.update(model: model);
  }
}
