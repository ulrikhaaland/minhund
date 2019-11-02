import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:minhund/model/user.dart';
import 'package:minhund/provider/crud_provider.dart';
import 'package:minhund/provider/dog_provider.dart';

class UserProvider extends CrudProvider {
  String path = "users";

  Future updateFcmToken(User user, FirebaseMessaging firebaseMessaging) =>
      firebaseMessaging.getToken().then((token) {
        if (user.fcm != token) {
          user.fcm = token;
          update(model: user);
        } else {
          return;
        }
      });

  Future get({String id, model: User}) async {
    User user;

    DocumentSnapshot docSnap = await super.get(id: path + "/" + id);

    if (docSnap.exists) {
      user = User.fromJson(docSnap.data);
      user.docRef = docSnap.reference;
    }

    return user;
  }

  Future set({String id, dynamic model}) async {
    return super.set(id: path + "/$id", model: model);
  }

  @override
  Future<DocumentReference> create({dynamic model, String id}) {
    return super.create(model: model, id: path);
  }

  @override
  Future getCollection({String id}) {
    return super.getCollection(id: id);
  }
}
