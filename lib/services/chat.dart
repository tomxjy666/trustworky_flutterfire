import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'dart:async';

class ChatService {
  String email;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  // FirebaseUser user = await _auth.currentUser();

  inputData() async {
    final FirebaseUser user = await _auth.currentUser();
    email = user.email;
    // here you write the codes to input the data into firestore
    return email;
  }

  final CollectionReference roomCollection =
      Firestore.instance.collection('rooms');

  //update job status pending
  Future updateJobStatus(String roomId) {
    DocumentReference requestRef = _db.collection('rooms').document(roomId);

    return requestRef.updateData({
      'jobStatus': 'pending',
      'lastUpdated': DateTime.now()
    });
  }

  //update job status work done
  Future updateWorkDoneStatus(String roomId) {
    DocumentReference requestRef = _db.collection('rooms').document(roomId);

    return requestRef.updateData({
      'jobStatus': 'workDone',
      'lastUpdated': DateTime.now()
    });
  }    

  //update job status work done confimed
  Future confirmWorkDoneStatus(String roomId) {
    DocumentReference requestRef = _db.collection('rooms').document(roomId);

    return requestRef.updateData({
      'jobStatus': 'paid',
      'lastUpdated': DateTime.now()
    });
  } 

  // room list from snapshot
  List<Room> _roomListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Room(
          roomId: doc.documentID,
          requestDocId: doc.data['requestDocId'] ?? '',
          requestCompensation: doc.data['requestCompensation'] ?? '',
          requestCategory: doc.data['requestCategory'] ?? '',
          requester: doc.data['requester'] ?? '',
          requesterDisplayName: doc.data['requesterDisplayName'] ?? '',
          requesterPhotoUrl: doc.data['requesterPhotoUrl'] ?? '',
          serviceProvider: doc.data['serviceProvider'] ?? '',
          serviceProviderDisplayName: doc.data['serviceProviderDisplayName'] ?? '',
          serviceProviderPhotoUrl: doc.data['serviceProviderPhotoUrl'] ?? '');
    }).toList();
  }

  //get rooms stream
  Stream<List<Room>> get rooms {
    // prefs = await SharedPreferences.getInstance();
    // email = prefs.getString('email');
    print('@@@@@');
    print(email);
    return roomCollection.where("requester", isEqualTo: email).snapshots().map(_roomListFromSnapshot);
  }
}
