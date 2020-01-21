import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FriendRequestScreen extends StatefulWidget {
  final String userUid;

  FriendRequestScreen({Key key, @required this.userUid}) : super(key: key);

  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  SharedPreferences prefs;
  FriendService friend = FriendService();
  var listReview;
  String uid;
  String name;
  String photoUrl;

  @override
  Widget build(BuildContext context) {
    Widget buildItem(int index, DocumentSnapshot document) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(document['friendRequesterPhotoUrl']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(document['friendRequesterDisplayName']),
          subtitle: Text(document['status']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.clear, color: Colors.red),
                onPressed: () async {
                  prefs = await SharedPreferences.getInstance();
                  uid = prefs.getString('id');
                  await friend.declineFriendRequest(uid, document['friendRequesterUid']);
                },
              ),
              new IconButton(
                icon: new Icon(Icons.done, color: Colors.green),
                onPressed: () async {
                  prefs = await SharedPreferences.getInstance();
                  uid = prefs.getString('id');
                  name = prefs.getString('displayName');
                  photoUrl = prefs.getString('photoUrl');
                  await friend.acceptFriendRequest(uid, document['friendRequesterUid']);
                  // add to current user friend list
                  await friend.addFriend(uid, document['friendRequesterUid'],document['friendRequesterDisplayName'], document['friendRequesterPhotoUrl']);
                  // add to opposite user friend list
                  await friend.addFriend(document['friendRequesterUid'], uid, name, photoUrl );
                },
              )
            ],
          ),
        ),
      );
    }

    Widget buildListReview() {
      // return Flexible(
      return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userUid)
            .collection('friendRequests')
            // .orderBy('lastUpdated', descending: true)
            // .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
          } else {
            listReview = snapshot.data.documents;
            // print(listReview['reviewers']);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
        // ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Friend Requests',
              style: TextStyle(
                fontFamily: 'ProductSans',
                color: Colors.white,
              )),
        ),
        body: buildListReview());
  }
}
