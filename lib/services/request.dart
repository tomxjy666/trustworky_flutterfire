import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class RequestService {
  final Firestore _db = Firestore.instance;

  final CollectionReference requestCollection =
      Firestore.instance.collection('requests');

  Future updateRequestData(FirebaseUser user, String title, String location,
      String compensation, String description) {
    DocumentReference requestRef = _db.collection('requests').document();

    return requestRef.setData({
      'id': uuid.v1(),
      'title': title,
      'location': location,
      'compensation': compensation,
      'description': description,
      'requesterDisplayName': user.displayName,
      'requesterUid': user.uid,
      'requesterPhotoUrl': user.photoUrl,
      'lastUpdated': DateTime.now()
    }, merge: true);
  }

  // request list from snapshot
  List<Request> _requestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Request(
          id: doc.data['id'] ?? '',
          title: doc.data['title'] ?? '',
          location: doc.data['location'] ?? '',
          compensation: doc.data['compensation'] ?? '',
          description: doc.data['description'] ?? '',
          requesterUid: doc.data['requesterUid'] ?? '',
          requesterDisplayName: doc.data['requesterDisplayName'] ?? '',
          requesterPhotoUrl: doc.data['requesterPhotoUrl'] ?? '',
          lastUpdated: doc.data['lastUpdated'] 
          );
    }).toList();
  }

  // get requests stream
  Stream<List<Request>> get requests {
    return requestCollection.snapshots()
      .map(_requestListFromSnapshot);
  }
}
