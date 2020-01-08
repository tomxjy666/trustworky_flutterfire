import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'dart:async';

class ChatService {
  String email;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseUser user = await _auth.currentUser();

  inputData() async {
    final FirebaseUser user = await _auth.currentUser();
    email = user.email;
    // here you write the codes to input the data into firestore
    return email;
  }

  final CollectionReference roomCollection =
      Firestore.instance.collection('rooms');

  // room list from snapshot
  List<Room> _roomListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Room(
          requestDocId: doc.data['requestDocId'] ?? '',
          requester: doc.data['requester'] ?? '',
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
