import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class CrudProvider {
  Future<dynamic> update({@required dynamic model}) {
    return model.docRef.updateData(model.toJson());
  }

  Future<DocumentReference> create(
      {@required dynamic model, @required String path}) {
    return Firestore.instance.collection(path).add(model.toJson());
  }

  Future getCollection({@required String path});

  Future<dynamic> read({@required String id});

  Future delete({@required dynamic model}) {
    return model.docRef.delete();
  }

  Future set({@required String id, @required dynamic model});
}
