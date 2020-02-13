import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chatbar/chatbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustworky_flutterfire/screens/publicProfileChat.dart';
// import 'package:trustworky_flutterfire/screens/screens.dart';
import 'package:trustworky_flutterfire/shared/shared.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ChatInboxScreen extends StatefulWidget {
  final String serviceProviderDisplayName;
  final String serviceProviderPhotoUrl;
  final String serviceProviderUid;
  final String serviceProvider;
  final String docId;
  final String requestId;
  final String requestCategory;
  final String requestCompensation;
  final String requestLocation;
  final String requestDescription;
  final String requesterUid;
  final String requesterAvatar;
  final String requesterDisplayName;
  final String requesterEmail;

  ChatInboxScreen(
      {Key key,
      @required this.serviceProviderDisplayName,
      @required this.serviceProviderPhotoUrl,
      @required this.serviceProviderUid,
      @required this.serviceProvider,
      @required this.docId,
      @required this.requestId,
      @required this.requestCategory,
      @required this.requestCompensation,
      @required this.requestLocation,
      @required this.requestDescription,
      @required this.requesterUid,
      @required this.requesterDisplayName,
      @required this.requesterAvatar,
      @required this.requesterEmail})
      : super(key: key);

  @override
  _ChatInboxScreenState createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  RequestService req = RequestService();
  ChatService chat = ChatService();
  bool _isVisible = true;
  bool _isAcceptOfferButtonVisible = false;
  bool _isDeclineOfferButtonVisible = false;
  bool _isConfirmWorkDoneButtonVisible = false;
  bool _isReviewButtonVisible = false;
  String uid;
  String email;
  String review = '';
  String error = '';
  double rating = 3.0;

  var listMessage;
  var roomData;
  var jobStatus;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  // bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    // get currentUser unique id
    uid = prefs.getString('id') ?? '';
    // get currentUser unique email
    // email = prefs.getString('email') ?? '';
    // set groupchatId = request docs id + unique email of serviceProvider
    groupChatId = '${widget.docId}-${widget.serviceProvider}';
    // Firestore.instance.collection('users').document(uid).updateData({'chattingWith': peerId});
    setState(() {});
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('rooms')
          .document(groupChatId)
          .collection('messages')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': uid,
            'idTo': widget.requesterUid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
      print('nothing to send');
    }
  }

  @override
  void initState() {
    super.initState();
    groupChatId = '';

    isLoading = false;
    // isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: Colors.green,
              ),
            ),
            color: Colors.white,
          ),
          // Material(
          //   child: new Container(
          //     margin: new EdgeInsets.symmetric(horizontal: 1.0),
          //     child: new IconButton(
          //       icon: new Icon(Icons.face),
          //       onPressed: getSticker,
          //       color: primaryColor,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                // focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.green,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('rooms')
                  .document(groupChatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  // width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullPhoto(url: document['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  : document['type'] == 2
                      // Offer
                      ? Container(
                          child: Text(
                            document['content'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          // width: 200.0,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(212, 234, 244, 1.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        )
                      // Sticker
                      : Container(
                          child: new Image.asset(
                            'images/${document['content']}.gif',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: widget.serviceProviderPhotoUrl,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        // width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : document['type'] == 2
                            // Offer
                            ? Container(
                                child: Text(
                                  document['content'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                // width: 200.0,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(212, 234, 244, 1.0),
                                    borderRadius: BorderRadius.circular(8.0)),
                                margin: EdgeInsets.only(left: 10.0),
                              )
                            : Container(
                                child: new Image.asset(
                                  'images/${document['content']}.gif',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    bottom:
                                        isLastMessageRight(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ChatBar(
        onprofileimagetap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PublicProfileChatScreen(userUid: widget.serviceProviderUid)));
        },
        color: Colors.green,
        profilePic: widget.serviceProviderPhotoUrl,
        username: widget.serviceProviderDisplayName,
        lastseen: '',
        status: ChatBarState.LASTSEEN,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('changed visibility');
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            icon: Icon(Icons.info_outline),
            color: Colors.white,
            splashColor: Colors.blue,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _isVisible,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: groupChatId == ''
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green)))
                    : StreamBuilder(
                        stream: Firestore.instance
                            .collection('rooms')
                            .document(groupChatId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green)));
                          } else {
                            roomData = snapshot.data;

                            if (roomData['jobStatus'] == null) {
                              jobStatus = 'open';
                            } else {
                              jobStatus = roomData['jobStatus'];
                            }

                            if (roomData['jobStatus'] == 'workDone') {
                              _isConfirmWorkDoneButtonVisible = true;
                            }
                            if (roomData['jobStatus'] == 'paid') {
                              _isConfirmWorkDoneButtonVisible = false;
                            }
                            if (roomData['jobStatus'] == 'negotiating') {
                              _isDeclineOfferButtonVisible = true;
                              _isAcceptOfferButtonVisible = true;
                            }
                            if (roomData['jobStatus'] == 'pending') {
                              _isDeclineOfferButtonVisible = false;
                              _isAcceptOfferButtonVisible = false;
                            }
                            if (roomData['jobStatus'] == 'open') {
                              _isDeclineOfferButtonVisible = false;
                              _isAcceptOfferButtonVisible = false;
                            }
                            if (roomData['jobStatus'] == 'paid' &&
                                roomData['reviewRequester'] == null) {
                              _isReviewButtonVisible = true;
                              _isConfirmWorkDoneButtonVisible = false;
                              _isAcceptOfferButtonVisible = false;
                              _isDeclineOfferButtonVisible = false;
                            }
                            if (roomData['jobStatus'] == 'paid' &&
                                roomData['reviewRequester'] == true) {
                              _isReviewButtonVisible = false;
                              _isConfirmWorkDoneButtonVisible = false;
                              _isAcceptOfferButtonVisible = false;
                              _isDeclineOfferButtonVisible = false;
                            }
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Chip(
                                  // avatar: CircleAvatar(
                                  //   backgroundColor: Colors.grey[300],

                                  // ),
                                  label: Text(jobStatus),
                                ),
                                title: Text(
                                    '${widget.requestCategory} @ ${widget.requestLocation}'),
                                subtitle: Text(widget.requestDescription),
                                trailing: Text(
                                  'S\$${widget.requestCompensation}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  Visibility(
                                    visible: _isDeclineOfferButtonVisible,
                                    child: FlatButton(
                                      child: const Text('DECLINE OFFER'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Confirm Decline Offer'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(true);
                                                    },
                                                    child: Text('CANCEL'),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () async {
                                                      final String decline =
                                                          "DECLINED OFFER: S\$";

                                                      var documentReference =
                                                          Firestore.instance
                                                              .collection(
                                                                  'rooms')
                                                              .document(
                                                                  groupChatId)
                                                              .collection(
                                                                  'messages')
                                                              .document(DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString());

                                                      Firestore.instance
                                                          .runTransaction(
                                                              (transaction) async {
                                                        await transaction.set(
                                                          documentReference,
                                                          {
                                                            'idFrom': uid,
                                                            'idTo': widget
                                                                .requesterUid,
                                                            'timestamp': DateTime
                                                                    .now()
                                                                .millisecondsSinceEpoch
                                                                .toString(),
                                                            'content': decline +
                                                                roomData[
                                                                    'negoPrice'],
                                                            'type': 2
                                                          },
                                                        );
                                                      });

                                                      await chat.declineOffer(
                                                          groupChatId);
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(true);
                                                    },
                                                    child:
                                                        Text('DECLINE OFFER'),
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isAcceptOfferButtonVisible,
                                    child: MaterialButton(
                                      color: Colors.green,
                                      child: const Text('ACCEPT OFFER'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Confirm Accept Offer?'),
                                                content: Text(
                                                    'Once you accept the Service Provider\'s offer, you\'ll be able to leave a review for each other.'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(true);
                                                    },
                                                    child: Text('CANCEL'),
                                                  ),
                                                  FlatButton(
                                                      onPressed: () async {
                                                        final String accept =
                                                            "ACCEPTED OFFER: S\$";

                                                        var documentReference =
                                                            Firestore.instance
                                                                .collection(
                                                                    'rooms')
                                                                .document(
                                                                    groupChatId)
                                                                .collection(
                                                                    'messages')
                                                                .document(DateTime
                                                                        .now()
                                                                    .millisecondsSinceEpoch
                                                                    .toString());

                                                        Firestore.instance
                                                            .runTransaction(
                                                                (transaction) async {
                                                          await transaction.set(
                                                            documentReference,
                                                            {
                                                              'idFrom': uid,
                                                              'idTo': widget
                                                                  .requesterUid,
                                                              'timestamp': DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString(),
                                                              'content': accept +
                                                                  roomData[
                                                                      'negoPrice'],
                                                              'type': 2
                                                            },
                                                          );
                                                        });

                                                        await req
                                                            .updateRequestStatus(
                                                                widget.docId);
                                                        await chat.acceptOffer(
                                                            groupChatId,
                                                            roomData[
                                                                'negoPrice']);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(true);
                                                      },
                                                      child:
                                                          Text('ACCEPT OFFER'))
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isConfirmWorkDoneButtonVisible,
                                    child: FlatButton(
                                      child: const Text('CONFIRM WORK DONE'),
                                      onPressed: () async {
                                        await chat
                                            .confirmWorkDoneStatus(groupChatId);
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isReviewButtonVisible,
                                    child: MaterialButton(
                                      color: Colors.green,
                                      child: const Text('LEAVE REVIEW'),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Please write a review"),
                                                content: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      RatingBar(
                                                        initialRating: 5,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate: (val) {
                                                          print(val);
                                                          setState(() {
                                                            rating = val;
                                                          });
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          minLines: 3,
                                                          maxLines: 6,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              review = val;
                                                            });
                                                          },
                                                          cursorColor:
                                                              Colors.green,
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  'Write something...',
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              focusColor:
                                                                  Colors.green,
                                                              fillColor:
                                                                  Colors.green,
                                                              hoverColor:
                                                                  Colors.green,
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors.green[
                                                                          200])),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors.green[
                                                                          100])),
                                                              errorBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors.red[
                                                                          700])),
                                                              labelStyle: TextStyle(
                                                                  color: Colors.grey[700])),
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'Please leave a review';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: RaisedButton(
                                                            child: Text(
                                                              "SUBMIT",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
                                                                  .currentState
                                                                  .validate()) {
                                                                _formKey
                                                                    .currentState
                                                                    .save();
                                                                dynamic
                                                                    ratingFormData =
                                                                    await chat.leaveReviewRequester(
                                                                        roomData[
                                                                            'serviceProviderUid'],
                                                                        rating,
                                                                        review,
                                                                        roomData[
                                                                            'requesterDisplayName'],
                                                                        roomData[
                                                                            'requesterPhotoUrl']);
                                                                await chat
                                                                    .reviewStatusRequester(
                                                                        groupChatId);

                                                                // If the form is valid, display a Snackbar.
                                                                if (ratingFormData ==
                                                                    null) {
                                                                  setState(() {
                                                                    error =
                                                                        'submit fail';
                                                                  });
                                                                }
                                                                _scaffoldKey
                                                                    .currentState
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  content: Text(
                                                                      'Review submitted.'),
                                                                ));
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(true);
                                                              }
                                                            },
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
              ),
            ),
            buildListMessage(),
            buildInput(),
          ],
        ),
      ),
    );
  }
}
