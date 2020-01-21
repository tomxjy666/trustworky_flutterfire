import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  SharedPreferences prefs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;


  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> googleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      updateUserData(user);
      await prefs.setString('id', user.uid);
      await prefs.setString('email', user.email);
      await prefs.setString('displayName', user.displayName);
      await prefs.setString('photoUrl', user.photoUrl);
    
      print(user);
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<FirebaseUser> anonLogin() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    updateUserData(user);
    return user;
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference userRef = _db.collection('users').document(user.uid);

    return userRef.setData({
      'uid': user.uid,
      'email': user.email,
      'emailVerified': user.isEmailVerified,
      'phoneNumber': user.phoneNumber,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'lastActivity': DateTime.now()
    }, merge: true);

  }

  Future<void> signOut() {
    return _auth.signOut();
  }

}