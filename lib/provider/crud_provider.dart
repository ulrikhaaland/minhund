import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class CrudProvider {
  Firestore firestoreInstance = Firestore.instance;

  // Super returns void
  Future update({@required model}) {
    return model.docRef.updateData(model.toJson());
  }

  // Super returns a DocumentReference and populates the model with id and docref
  Future create({@required model, @required String id}) async {
    DocumentReference ref =
        await firestoreInstance.collection(id).add(model.toJson());
    try {
      model.id = ref.documentID;
      model.docRef = ref;
      update(model: model);
    } catch (e) {}

    return ref;
  }

  // Super returns a query snapshot
  Future getCollection({@required String id}) async {
    return await firestoreInstance.collection(id).getDocuments();
  }

  // Super returns a document snapshot
  Future get({
    @required String id,
  }) async {
    return await firestoreInstance.document(id).get();
  }

  // Super returns void
  Future delete({@required model}) {
    return model.docRef.delete();
  }

  // Super returns Document Reference
  Future<DocumentReference> set({@required String id, @required model}) async {
    DocumentReference ref = firestoreInstance.document(id);
     await ref.setData(model.toJson());
     return ref;
  }
}
