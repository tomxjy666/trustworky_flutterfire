import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
import 'package:trustworky_flutterfire/shared/shared.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedInWrapperScreen extends StatefulWidget {
  LoggedInWrapperScreen({Key key}) : super(key: key);

  @override
  _LoggedInWrapperScreenState createState() => _LoggedInWrapperScreenState();
}

class _LoggedInWrapperScreenState extends State<LoggedInWrapperScreen> with WidgetsBindingObserver{
  int _currentIndex;
  final List<Widget> _children = [RequestCategoryScreen(), TasksScreen  (), HomeScreen(), InboxScreen(), ProfileScreen()];
  AuthService _auth = AuthService();
  SharedPreferences prefs;
  String uid;

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    // get currentUser unique id
    uid = prefs.getString('id') ?? '';
  }

  @override
  void initState() {
    super.initState();
    readLocal();
    _auth.updateUserStatusOnline(uid);
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = 2;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("APP_STATE: $state");
    readLocal();
    if(state == AppLifecycleState.resumed){
      // user returned to our app
     _auth.updateUserStatusOnline(uid);
    }else if(state == AppLifecycleState.inactive){
      // app is inactive
      _auth.updateUserStatusOffline(uid);
    }else if(state == AppLifecycleState.paused){
      // user quit our app temporally
      _auth.updateUserStatusOffline(uid);
    }else if(state == AppLifecycleState.detached){
      // app suspended
      _auth.updateUserStatusOffline(uid);
    }
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
