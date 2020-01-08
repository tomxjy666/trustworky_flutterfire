import 'package:flutter/material.dart';
import 'package:trustworky_flutterfire/screens/inbox_task.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
// import 'package:trustworky_flutterfire/screens/inbox_list.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Inbox',
              style: TextStyle(
                fontFamily: 'ProductSans',
                color: Colors.black,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'My Requests'),
                Tab(text: 'My Tasks'),
              ],
            ),
            backgroundColor: Colors.white
            ),
        body: TabBarView(
          children: [
            InboxRequest(),
            InboxTask()
          ],
        ),
      ),
    );
  }
}
