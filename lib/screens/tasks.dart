import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:trustworky_flutterfire/screens/task_list.dart';
// import '../shared/shared.dart';

class TasksScreen extends StatelessWidget {
  // const TasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Request>>.value(
      value: RequestService().requests,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Available Tasks',
              style: TextStyle(fontFamily: 'ProductSans', color: Colors.black),
            ),
            backgroundColor: Colors.white),
        body: TaskList(),    
      ),
    );
  }
}
