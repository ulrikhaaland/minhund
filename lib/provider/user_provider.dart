import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:minhund/model/dog.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/provider/crud_provider.dart';

class UserProvider<T> {
  Firestore _firestoreInstance = Firestore.instance;

  Future update(User user) => user.docRef.updateData(user.toJson());

  Future updateFcmToken(User user, FirebaseMessaging firebaseMessaging) =>
      firebaseMessaging.getToken().then((token) {
        user.fcm = token;
        update(user);
      });

  Future<User> get({String id, bool withDogs}) async {
    User user;

    DocumentSnapshot docSnap =
        await _firestoreInstance.document("users/$id").get();

    if (docSnap.exists) {
      user = User.fromJson(docSnap.data);
      user.docRef = docSnap.reference;
      user.dogs = [];

      if (withDogs) {
        QuerySnapshot qSnap =
            await user.docRef.collection("dogs").getDocuments();
        qSnap.documents.forEach((dog) {
          Dog duggy = Dog.fromJson(dog.data);
          duggy.docRef = dog.reference;
          user.dogs.add(duggy);
        });
      }
    }

    return user;
  }

  Future set(User user) async {
    _firestoreInstance.document("users/${user.id}").setData(user.toJson());
  }
}
