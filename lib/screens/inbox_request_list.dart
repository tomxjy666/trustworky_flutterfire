import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:trustworky_flutterfire/screens/inbox_request_tile.dart';

class InboxRequestList extends StatefulWidget {
  @override
  _InboxRequestListState createState() => _InboxRequestListState();
}

class _InboxRequestListState extends State<InboxRequestList> {
  @override
  Widget build(BuildContext context) {

    final rooms = Provider.of<List<Room>>(context);
 
    return ListView.builder(
      // separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: rooms?.length ?? 0,
      itemBuilder: (context, index) {
        return InboxRequestTile(room: rooms[index]);
      },
      
    );
  }
}