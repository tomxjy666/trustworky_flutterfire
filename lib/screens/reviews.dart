import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewScreen extends StatefulWidget {
  final String userUid;

  ReviewScreen({Key key, @required this.userUid}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var listReview;
  // final ScrollController listScrollController = new ScrollController();

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
                  Icon(Icons.star)
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
                    .collection('reviews')
                    // .orderBy('lastUpdated', descending: true)
                    // .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green)));
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
          title: Text('Reviews',
              style: TextStyle(
                fontFamily: 'ProductSans',
                color: Colors.white,
              )),
        ),
        body: buildListReview());
  }
}
