import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.headset, size: 20),
            title: Text('Topics')),
        BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, size: 20),
            title: Text('About')),
        BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 20),
            title: Text('Profile')),
      ].toList(),
      fixedColor: Colors.deepPurple[200],
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // do nuttin
            break;
          case 1:
            Navigator.pushNamed(context, '/about');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}