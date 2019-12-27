import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inbox', style: TextStyle(fontFamily: 'ProductSans', color: Colors.black,),), backgroundColor: Colors.white),

      body: Center(child: Text('chat lives here..'),),
    );
  }
}