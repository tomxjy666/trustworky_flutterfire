import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:trustworky_flutterfire/screens/task_tile.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {

    final requests = Provider.of<List<Request>>(context);
 
    return ListView.builder(
      // separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: requests?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskTile(request: requests[index]);
      },
      
    );
  }
}