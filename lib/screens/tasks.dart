import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks', style: TextStyle(fontFamily: 'ProductSans', color: Colors.black,),), backgroundColor: Colors.white),

      body: Center(child: Text('tasks list lives here..'),),
    );
  }
}