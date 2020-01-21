import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListScreen extends StatefulWidget {
  final String userUid;

  FriendListScreen({Key key, @required this.userUid}) : super(key: key);

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  var listFriend;
  // final ScrollController listScrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {

    Widget buildFriendItem(int index, DocumentSnapshot document) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(document['friendPhotoUrl']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(document['name']),
          // subtitle: Text(document['friendUid']),
          // trailing: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: <Widget>[
          //     Text(document['rating'].toString()),
          //     Icon(
          //       Icons.star,
          //       color: Colors.green,
          //     )
          //   ],
          // ),
        ),
      );
    }

    Widget buildListFriend() {
      // return Flexible(
      return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userUid)
            .collection('friends')
            // .orderBy('lastUpdated', descending: true)
            // .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
          } else {
            listFriend = snapshot.data.documents;
            // print(listReview['reviewers']);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildFriendItem(index, snapshot.data.documents[index]),
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
          title: Text('My Friends',
              style: TextStyle(
                fontFamily: 'ProductSans',
                color: Colors.white,
              )),
        ),
        body: buildListFriend());
  }
}
