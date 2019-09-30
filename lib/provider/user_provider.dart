import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/dog_provider.dart';

class UserProvider extends CrudProvider {
  Firestore _firestoreInstance = Firestore.instance;

  Future updateFcmToken(User user, FirebaseMessaging firebaseMessaging) =>
      firebaseMessaging.getToken().then((token) {
        user.fcm = token;
        update(model: user);
      });

  Future read({@required String id}) async {
    User user;

    String path = "users/$id";

    DocumentSnapshot docSnap = await _firestoreInstance.document(path).get();

    if (docSnap.exists) {
      user = User.fromJson(docSnap.data);
      user.docRef = docSnap.reference;
      user.dogs = await DogProvider().getCollection(path: path);
    }

    return user;
  }

  Future set({String id, dynamic model}) async {
    _firestoreInstance.document("users/$id").setData(model.toJson());
  }

  @override
  Future<DocumentReference> create({dynamic model, String path}) {
    return super.create(model: model, path: path);
  }

  @override
  Future delete({model}) {
    // TODO: implement delete
    return super.delete(model: model);
  }

  @override
  Future getCollection({String path}) {
    // TODO: implement getCollection
    return null;
  }

  @override
  Future update({model}) {
    return super.update(model: model);
  }
}
