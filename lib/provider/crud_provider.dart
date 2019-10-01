import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class CrudProvider<T> {
  Firestore firestoreInstance = Firestore.instance;
  Future<dynamic> update({@required dynamic model}) {
    return model.docRef.updateData(model.toJson());
  }

  Future<DocumentReference> create(
      {@required dynamic model, @required String path}) async {
    DocumentReference ref =
        await firestoreInstance.collection(path).add(model.toJson());
    model.id = ref.documentID;
    model.docRef = ref;
    return ref;
  }

  Future getCollection({@required String path});

  Future<dynamic> read({@required String id, @required T model}) async {
    DocumentSnapshot docSnap = await firestoreInstance.document(id).get();
    T user = user.toJson(docSnap.data);
    model.docRef = docSnap.reference;
    return model;
  }

  Future delete({@required dynamic model}) {
    return model.docRef.delete();
  }

  Future set({@required String id, @required dynamic model});
}
