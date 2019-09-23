import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:minhund/model/user.dart';

class UserProvider {
  Firestore _firestoreInstance = Firestore.instance;

  Future update(User user) =>
      _firestoreInstance.document("users/${user.id}").updateData(user.toJson());

  Future updateFcmToken(User user, FirebaseMessaging firebaseMessaging) =>
      firebaseMessaging.getToken().then((token) {
        user.fcm = token;
        update(user);
      });

  Future<User> get(String id) async {
    User user;

    DocumentSnapshot docSnap =
        await _firestoreInstance.document("users/$id").get();

    if (docSnap.exists) {
      user = User.fromJson(docSnap.data);
      user.docRef = docSnap.reference;
    }

    return user;
  }

  Future set(User user) =>
      _firestoreInstance.document("users/${user.id}").setData(user.toJson());
}
