import 'package:cloud_firestore/cloud_firestore.dart';

class CrudProvider {
  Firestore _firestoreInstance = Firestore.instance;

  Future update(dynamic model) {
    return model.docRef.updateData(model.toJson());
  }

  Future create(dynamic model, String path) {
    if (model.id != null) {
      return update(model);
    } else {
      _firestoreInstance.collection(path).add(model.toJson()).then((docRef) {
        model.docRef = docRef;
        model.id = docRef.documentID;
        update(model);
        return model;
      });
    }
  }

  Future getCollection(String path) async {
    return await _firestoreInstance.collection(path).getDocuments();
  }

  Future read(String path, dynamic model) async {
    DocumentSnapshot docSnap = await _firestoreInstance.document(path).get();
    return model.fromJson(docSnap.data);
  }

  Future delete(dynamic model) {
    return model.docRef.delete();
  }
}
