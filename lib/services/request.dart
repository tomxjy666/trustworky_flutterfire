import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
// import 'package:trustworky_flutterfire/services/models.dart';

var uuid = Uuid();

class RequestService {
  final Firestore _db = Firestore.instance;

  Future updateRequestData(FirebaseUser user, String title, String location, String compensation, String description) {
    DocumentReference requestRef = _db.collection('requests').document();

    return requestRef.setData({
      'id': uuid.v1(),
      'title': title,
      'location': location,
      'compensation': compensation,
      'description': description,
      'requesterDisplayName': user.displayName,
      'requesterUid': user.uid,
      'lastUpdated': DateTime.now()
    }, merge: true);

  }
  
}