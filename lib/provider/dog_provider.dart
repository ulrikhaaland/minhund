import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/journal_provider.dart';

class DogProvider extends CrudProvider {
  Firestore firestoreInstance = Firestore.instance;

  Dog dog;

  @override
  Future<DocumentReference> create({dynamic model, String id}) {
    String path = "users/$id/dogs";
    return super.create(model: model, id: path).then((docRef) {
      if (model.journalItems.isNotEmpty) {
        model.journalItems.forEach((item) {
          JournalProvider().create(id: path + "/" + model.id, model: item);
        });
      }
      return docRef;
    });
  }

  @override
  Future<List<Dog>> getCollection({String id}) async {
    List<Dog> list = [];
    String path = "users/$id/dogs";
    QuerySnapshot qSnap = await super.getCollection(id: path);
    if (qSnap.documents.isNotEmpty) {
      qSnap.documents.forEach((doc) {
        Dog dog = Dog.fromJson(doc.data);
        dog.docRef = doc.reference;
        list.add(dog);
      });
    }
    return list;
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
}
