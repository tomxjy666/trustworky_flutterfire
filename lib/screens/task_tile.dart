import 'package:flutter/material.dart';
import 'package:trustworky_flutterfire/services/services.dart';

class TaskTile extends StatelessWidget {

  final Request request;
  TaskTile({ this.request });
  @override
  Widget build(BuildContext context) {
    String profilePicture = request.requesterPhotoUrl.replaceAll('s96-c', 's400-c');
    return Padding(
      padding: EdgeInsets.only(top:0.2),
      child: Card(
        // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(profilePicture),
            backgroundColor: Colors.transparent,
          ),
          title: Text(request.title),
          subtitle: Text('S\$${request.compensation}'),
          trailing: Text(request.location),
          onTap: () => print('tapped'),
        ),
      ),
      
    );
  }
}