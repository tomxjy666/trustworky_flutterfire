import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InboxRequestTile extends StatefulWidget {
  final Room room;
  InboxRequestTile({this.room});

  @override
  _InboxRequestTileState createState() => _InboxRequestTileState();
}

class _InboxRequestTileState extends State<InboxRequestTile> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (widget.room.requester == user.email) {
      _isVisible = true;
    }
    // String profilePicture =
    //     room.serviceProviderPhotoUrl.replaceAll('s96-c', 's400-c');
    var requestData;
    var documentReference =
        Firestore.instance.collection('requests').document(widget.room.requestDocId);
    Firestore.instance.runTransaction((transaction) async {
      print('CALLED@@@@@@@@@@@@@@@@@@');
      await transaction.get(documentReference).then((result) {
        print(result.data.toString());
        requestData = result.data;
      });
    });

    return Padding(
      padding: EdgeInsets.only(top: 0.2),
      child: Card(
        // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: Visibility(
          visible: _isVisible,
                  child: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(widget.room.serviceProviderPhotoUrl),
                backgroundColor: Colors.transparent,
              ),
              title: Text(widget.room.serviceProviderDisplayName),
              subtitle: Text(widget.room.requestCategory),
              // trailing: Text(request.location),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatInboxScreen(
                        serviceProviderPhotoUrl: widget.room.serviceProviderPhotoUrl,
                        serviceProviderDisplayName: widget.room.serviceProviderDisplayName,
                        serviceProvider: widget.room.serviceProvider,
                        docId: widget.room.requestDocId,
                        requestId: requestData['id'],
                        requestCategory: requestData['category'],
                        requestCompensation: requestData['compensation'],
                        requestDescription: requestData['description'],
                        requestLocation: requestData['location'],
                        requesterUid: requestData['requesterUid'],
                        requesterDisplayName: requestData['requesterDisplayName'],
                        requesterAvatar: requestData['requesterPhotoUrl'],
                        requesterEmail: requestData['requesterEmail']),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
