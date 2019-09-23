import 'package:cloud_firestore/cloud_firestore.dart';

class CrudProvider {
  Firestore _firestoreInstance = Firestore.instance;

  Future update(dynamic model) {
    return model.docRef.updateData(model.toJson());
  }

  Future create(dynamic model, String path) {
    return _firestoreInstance
        .collection(path)
        .add(model.toJson())
        .then((docRef) {
      model.docRef = docRef;
      model.id = docRef.documentID;
    });
  }

  Future getCollection(String path) async {
    return await _firestoreInstance.collection(path).getDocuments();
  }

  Future<DocumentSnapshot> read(String path) async {
    return await _firestoreInstance.document(path).get();
  }

  Future delete(dynamic model) {
    return model.docRef.delete();
  }
}
