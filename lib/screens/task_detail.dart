import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:provider/provider.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailScreen extends StatefulWidget {
  final Request request;

  TaskDetailScreen({Key key, @required this.request}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    // RequestService req = RequestService();
    SharedPreferences prefs;
    String groupChatId;
    String email;
    String formatted = formatTime((widget.request.lastUpdated.seconds) * 1000);
    if (widget.request.requesterUid == user.uid) {
      _isVisible = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.request.category,
          style: TextStyle(fontFamily: 'ProductSans', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Container(
                child: Column(
          children: <Widget>[
            Text(widget.request.category),
            Text(widget.request.compensation),
            Text(widget.request.description),
            Text(widget.request.location),
            Text(widget.request.requesterDisplayName),
            Text(widget.request.requesterEmail),
            Text(formatted)
          ],
        ))),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(Icons.forum),
          label: const Text('Chat'),
          onPressed: () async {
            prefs = await SharedPreferences.getInstance();
            email = prefs.getString('email');
            groupChatId = '${widget.request.docId}-$email';

            var documentReference =
                Firestore.instance.collection('rooms').document(groupChatId);

            Firestore.instance.runTransaction((transaction) async {
              await transaction.set(
                documentReference,
                {
                  'serviceProvider': email,
                  'serviceProviderDisplayName': user.displayName,
                  'serviceProviderPhotoUrl': user.photoUrl,
                  'requester': widget.request.requesterEmail,
                  'requesterDisplayName': widget.request.requesterDisplayName,
                  'requesterPhotoUrl': widget.request.requesterPhotoUrl,
                  'requestDocId': widget.request.docId,
                  'requestCategory': widget.request.category,
                  'requestCompensation': widget.request.compensation
                  // 'created': DateTime.now().millisecondsSinceEpoch.toString()
                },
              );
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        docId: widget.request.docId,
                        requestId: widget.request.id,
                        requestCategory: widget.request.category,
                        requestCompensation: widget.request.compensation,
                        requestDescription: widget.request.description,
                        requestLocation: widget.request.location,
                        requesterUid: widget.request.requesterUid,
                        requesterDisplayName:
                            widget.request.requesterDisplayName,
                        requesterAvatar: widget.request.requesterPhotoUrl,
                        requesterEmail: widget.request.requesterEmail)));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
