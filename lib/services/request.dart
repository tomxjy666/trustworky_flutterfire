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

  // post new request
  Future updateRequestData(FirebaseUser user, String category, String location,
      String compensation, String description) {
    DocumentReference requestRef = _db.collection('requests').document();

    return requestRef.setData({
      'id': uuid.v1(),
      'status': 'open',
      'category': category,
      'location': location,
      'compensation': compensation,
      'description': description,
      'requesterDisplayName': user.displayName,
      'requesterUid': user.uid,
      'requesterEmail': user.email,
      'requesterPhotoUrl': user.photoUrl,
      'lastUpdated': DateTime.now()
    }, merge: true);
  }

  // update request status to closed
  Future updateRequestStatus(String docId) {
    DocumentReference requestRef = _db.collection('requests').document(docId);

    return requestRef.updateData({
      'status': 'closed',
      'lastUpdated': DateTime.now()
    });
  }

  

  // request list from snapshot
  List<Request> _requestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Request(
          docId: doc.documentID,
          id: doc.data['id'] ?? '',
          category: doc.data['category'] ?? '',
          location: doc.data['location'] ?? '',
          compensation: doc.data['compensation'] ?? '',
          description: doc.data['description'] ?? '',
          requesterUid: doc.data['requesterUid'] ?? '',
          requesterEmail: doc.data['requesterEmail'] ?? '',
          requesterDisplayName: doc.data['requesterDisplayName'] ?? '',
          requesterPhotoUrl: doc.data['requesterPhotoUrl'] ?? '',
          serviceProviders: doc.data['serviceProviders'],
          lastUpdated: doc.data['lastUpdated'] 
          );
    }).toList();
  }

  // get requests stream
  Stream<List<Request>> get requests {
    return requestCollection.where("status", isEqualTo: "open" ).snapshots()
      .map(_requestListFromSnapshot);
  }


}
