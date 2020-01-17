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
  Future acceptListedRate(String roomId, String finalisedCompensation) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'jobStatus': 'pending',
      'finalisedCompensation': finalisedCompensation,
      'lastUpdated': DateTime.now()
    });
  }

  //update job status work done
  Future updateWorkDoneStatus(String roomId) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'jobStatus': 'workDone',
      'lastUpdated': DateTime.now()
    });
  }    

  //update job status work done confimed
  Future confirmWorkDoneStatus(String roomId) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'jobStatus': 'paid',
      'lastUpdated': DateTime.now()
    });
  }

  //update job price negotiation
  Future negotiatePrice(String roomId, String price, String email) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'negoPrice': price,
      'negoUser': email,
      'lastUpdated': DateTime.now()
    });
  }

  //update job status negotiating
  Future updateNegoStatus(String roomId) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'jobStatus': 'negotiating',
      'lastUpdated': DateTime.now()
    });
  }

  //accept counter offer
  Future acceptOffer(String roomId, String finalisedCompensation) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'jobStatus': 'pending',
      'finalisedCompensation': finalisedCompensation,
      'lastUpdated': DateTime.now()
    });
  }

  //decline counter offer
  Future declineOffer(String roomId) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'jobStatus': 'open',
      'lastUpdated': DateTime.now()
    });
  }

  //update review status service provider
  Future reviewStatusServiceProvider(String roomId) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'reviewServiceProvider': true,
      'lastUpdated': DateTime.now()
    });
  }

  //update review status requester
  Future reviewStatusRequester(String roomId) {
    DocumentReference roomRef = _db.collection('rooms').document(roomId);

    return roomRef.updateData({
      'reviewRequester': true,
      'lastUpdated': DateTime.now()
    });
  }



  //leave review
  Future leaveReview(String userUid, double rating, String review, String reviewer, String reviewerPhotoUrl) {
    DocumentReference userRef = _db.collection('users').document(userUid).collection('reviews').document();

    return userRef.setData({
      'from': 'service provider',
      'reviewer': reviewer,
      'reviewerPhotoUrl': reviewerPhotoUrl,
      'content': review,
      'rating': rating,
      'lastUpdated': DateTime.now()
    });
  }

  //leave review
  Future leaveReviewRequester(String userUid, double rating, String review, String reviewer, String reviewerPhotoUrl) {
    DocumentReference userRef = _db.collection('users').document(userUid).collection('reviews').document();

    return userRef.setData({
      'from': 'requester',
      'reviewer': reviewer,
      'reviewerPhotoUrl': reviewerPhotoUrl,
      'content': review,
      'rating': rating,
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
