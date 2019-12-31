import 'package:flutter/material.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:time_formatter/time_formatter.dart';

class TaskDetailScreen extends StatelessWidget {
  final Request request;

  TaskDetailScreen({Key key, @required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatted = formatTime((request.lastUpdated.seconds) * 1000 );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          request.category,
          style: TextStyle(fontFamily: 'ProductSans', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Container(
                child: Column(
          children: <Widget>[
            Text(request.category),
            Text(request.compensation),
            Text(request.description),
            Text(request.location),
            Text(request.requesterDisplayName),
            Text(formatted)
          ],
        ))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.forum),
        label: const Text('Chat'),
        onPressed: () {
          print(request.lastUpdated);
          print(formatted);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
