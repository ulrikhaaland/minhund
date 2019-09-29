import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> verifyPhoneNumber(
      {String phoneNumber, void Function(String id) theId});
  Future<FirebaseUser> signInWithPhone(String id, String smsCode);
  Future<FirebaseUser> asAnon();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
      {String phoneNumber, void Function(String id) theId}) async {
    String _verificationId;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      _verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      _verificationId = verId;
      theId(verId);
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) {
      _firebaseAuth.signInWithCredential(credential);
      print("verified");
    };

    final PhoneVerificationFailed veriFailed = (AuthException e) {
      print(e.message);
    };
    await _firebaseAuth
        .verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verifiedSuccess,
      codeSent: smsCodeSent,
      verificationFailed: veriFailed,
      codeAutoRetrievalTimeout: autoRetrieve,
      timeout: Duration(seconds: 5),
    )
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<FirebaseUser> asAnon() {
    return _firebaseAuth.signInAnonymously();
  }

  Future<void> resetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> signInWithPhone(String id, String smsCode) async {
    FirebaseUser user;
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: id,
      smsCode: smsCode,
    );
    try {
      user = await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print(e.message);
    }
    return user;
  }
}
