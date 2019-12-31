import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
import 'package:trustworky_flutterfire/shared/shared.dart';

class LoggedInWrapperScreen extends StatefulWidget {
  LoggedInWrapperScreen({Key key}) : super(key: key);

  @override
  _LoggedInWrapperScreenState createState() => _LoggedInWrapperScreenState();
}

class _LoggedInWrapperScreenState extends State<LoggedInWrapperScreen> {
  int _currentIndex;
  final List<Widget> _children = [RequestScreen(), TasksScreen(), HomeScreen(), InboxScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
    _currentIndex = 2;
  }

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.add_circle,
                size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
              title: Text("Request")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.assignment,
                size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.assignment,
                color: Colors.green,
              ),
              title: Text("Tasks")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(                
                CustomIcons.trustworky,
                // size: 24,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                CustomIcons.trustworky,
                size: 20,
                color: Colors.green,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.forum,
                size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.forum,
                color: Colors.green,
              ),
              title: Text("Inbox")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: Colors.green,
              ),
              title: Text("Profile"))
        ],
      ),
    );
  }
}
