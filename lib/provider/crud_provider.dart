import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class CrudProvider {
  Firestore firestoreInstance = Firestore.instance;

  // Super returns void
  Future update({@required dynamic model}) {
    return model.docRef.updateData(model.toJson());
  }

  // Super returns a DocumentReference and populates the model with id and docref
  Future<DocumentReference> create(
      {@required dynamic model, @required String id}) async {
    DocumentReference ref =
        await firestoreInstance.collection(id).add(model.toJson());
    model.id = ref.documentID;
    model.docRef = ref;
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
  Future delete({@required dynamic model}) {
    return model.docRef.delete();
  }

  // Super returns void
  Future set({@required String id, @required dynamic model}) async {
    return await firestoreInstance.document(id).setData(model.toJson());
  }
}
