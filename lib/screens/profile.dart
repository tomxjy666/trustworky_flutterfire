import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // Report report = Provider.of<Report>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      String profilePicture = user.photoUrl.replaceAll('s96-c', 's400-c');
      // dynamic activity = new DateTime.fromMillisecondsSinceEpoch(report.lastActivity * 1000);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(user.displayName ?? 'Guest', style: TextStyle(fontFamily: 'ProductSans', color: Colors.black,),),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (profilePicture != null)
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(top: 50, bottom: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(profilePicture),
                    ),
                  ),
                ),
              Text(user.email ?? '',
                  style: Theme.of(context).textTheme.title),
              Spacer(),
              // if (report != null)
                //  Text(activity,
                //      style: Theme.of(context).textTheme.display3),
                //  Text('Last Logged In',
                //      style: Theme.of(context).textTheme.subhead),
              Spacer(),
              FlatButton(
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.redAccent[400],
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }),
              Spacer()
            ],
          ),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
