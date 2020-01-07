import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
// import '../shared/shared.dart';

class InboxRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Room>>.value(
      value: ChatService().rooms,
      child: Scaffold(
        body: InboxRequestList(),    
      ),
    );
  }
}
