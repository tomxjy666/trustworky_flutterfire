import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FriendService {
  final Firestore _db = Firestore.instance;

  //decline friend requests
  Future declineFriendRequest(String userUid, String friendRequestUid) {
    DocumentReference friendRequetsRef = _db
        .collection('users')
        .document(userUid)
        .collection('friendRequests')
        .document(friendRequestUid);
    return friendRequetsRef.delete();
  }

  //accept friend requests
  Future acceptFriendRequest(String userUid, String friendRequestUid) {
    DocumentReference friendRequestRef = _db
        .collection('users')
        .document(userUid)
        .collection('friendRequests')
        .document(friendRequestUid);

    return friendRequestRef.delete();
  }

  Future addFriend(String userUid, String friendUid, String friendName, String friendPhotoUrl) {
    DocumentReference friendRef = _db
        .collection('users')
        .document(userUid)
        .collection('friends')
        .document(friendUid);

    return friendRef.setData({'name': friendName, 'friendUid': friendUid, 'friendPhotoUrl': friendPhotoUrl});
  }
}
