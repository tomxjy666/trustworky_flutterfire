import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PublicProfileChatScreen extends StatefulWidget {
  final userUid;
  PublicProfileChatScreen({Key key, @required this.userUid}) : super(key: key);
  @override
  _PublicProfileChatScreenState createState() =>
      _PublicProfileChatScreenState();
}

class _PublicProfileChatScreenState extends State<PublicProfileChatScreen> {
  SharedPreferences prefs;
  var listReview;
  var userData;
  var friendData;
  String uid;
  String friendRequesterDisplayName;
  String friendRequesterPhotoUrl;
  bool _isFriendRequestButtonVisible = false;

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    // get currentUser unique id
    uid = prefs.getString('id');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget buildItem(int index, DocumentSnapshot document) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(document['reviewerPhotoUrl']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(document['reviewer']),
          subtitle: Text(document['content']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(document['rating'].toString()),
              Icon(
                Icons.star,
                color: Colors.green,
              )
            ],
          ),
        ),
      );
    }

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

    Widget buildListReview() {
      // return Flexible(
      return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userUid)
            .collection('reviews')
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
              shrinkWrap: true,
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
            listReview = snapshot.data.documents;
            // print(listReview['reviewers']);
            return ListView.builder(
              shrinkWrap: true,
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: Firestore.instance
                .collection('users')
                .document(widget.userUid)
                .get(),
            builder: (context, ds) {
              if (!ds.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green)));
              } else {
                userData = ds.data;

                return Column(
                  children: <Widget>[
                    // SizedBox(
                    //   height: 32.0,
                    // ),
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Column(
                          //   children: <Widget>[
                          //     Text(
                          //       '27',
                          //       style: TextStyle(fontSize: 16.0),
                          //     ),
                          //     Text(
                          //       'Rating',
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //   ],
                          // ),
                          // Spacer(),
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['photoUrl']),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                userData['displayName'],
                                style: TextStyle(
                                  fontSize: 24.0,
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                userData['email'],
                                style: TextStyle(color: Colors.grey),
                              ),
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('users')
                                      .document(widget.userUid)
                                      .collection('friends')
                                      .where("friendUid", isEqualTo: uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      print('no data');
                                      // setState(() {_isFriendRequestButtonVisible = true;});
                                      // _isFriendRequestButtonVisible = true;
                                      return Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.green)));
                                    } else {
                                      print(
                                          snapshot.data.documents.length == 0);
                                      if (snapshot.data.documents.length == 0) {
                                        _isFriendRequestButtonVisible = true;
                                      }
                                      return Visibility(
                                        visible: _isFriendRequestButtonVisible,
                                        child: OutlineButton.icon(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                          ),
                                          label: Text("SEND FRIEND REQUEST",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.green)),
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.green,
                                            size: 20.0,
                                          ),
                                          onPressed: () async {
                                            prefs = await SharedPreferences
                                                .getInstance();
                                            // get currentUser unique id
                                            uid = prefs.getString('id');
                                            friendRequesterDisplayName =
                                                prefs.getString('displayName');
                                            friendRequesterPhotoUrl =
                                                prefs.getString('photoUrl');

                                            var documentReference = Firestore
                                                .instance
                                                .collection('users')
                                                .document(widget.userUid)
                                                .collection('friendRequests')
                                                .document(uid);

                                            Firestore.instance.runTransaction(
                                                (Transaction
                                                    transaction) async {
                                              DocumentSnapshot
                                                  friendRequestSnapshot =
                                                  await transaction
                                                      .get(documentReference);
                                              if (friendRequestSnapshot
                                                  .exists) {
                                                print('Request Exists');
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Request Already Sent!');
                                              } else {
                                                await transaction.set(
                                                  documentReference,
                                                  {
                                                    'friendRequesterPhotoUrl':
                                                        friendRequesterPhotoUrl,
                                                    'friendRequesterDisplayName':
                                                        friendRequesterDisplayName,
                                                    'friendRequesterUid': uid,
                                                    'status': 'pending'
                                                  },
                                                );
                                                Fluttertoast.showToast(
                                                    msg: 'Request Sent!');
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    }
                                  })
                            ],
                          ),
                          // Spacer(),
                          // Column(
                          //   children: <Widget>[
                          //     Text(
                          //       '27',
                          //       style: TextStyle(fontSize: 16.0),
                          //     ),
                          //     Text(
                          //       'Friends',
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(64.0, 0, 64.0, 0),
                      child: Container(
                        height: 1.0,
                        decoration: BoxDecoration(color: Colors.green[200]),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    Column(
                      children: <Widget>[
                        TabBar(
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.green,
                            labelColor: Colors.green,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                text: "Reviews",
                              ),
                              Tab(
                                text: "Friends",
                              ),
                            ]),
                        Container(
                          height: 450,
                          child: TabBarView(
                            children: <Widget>[
                              buildListReview(),
                              buildListFriend()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
