import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      String profilePicture = user.photoUrl.replaceAll('s96-c', 's400-c');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    CircleAvatar(backgroundImage: NetworkImage(profilePicture)),
              ),
              Text(user.displayName,
                  style: TextStyle(
                      fontFamily: 'ProductSans', color: Colors.black)),
            ],
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(FontAwesomeIcons.qrcode, color: Colors.black),
              onPressed: () {},
            ),
            new IconButton(
              icon: new Icon(FontAwesomeIcons.expand, color: Colors.black),
              onPressed: () {},
            )
          ],
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: 'Settings',
              tiles: [
                SettingsTile(
                  title: 'My Profile',
                  // subtitle: 'English',
                  leading: Icon(FontAwesomeIcons.idBadge),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PublicProfileScreen(user: user)));
                  },
                ),
                SettingsTile(
                  title: 'My Reviews',
                  // subtitle: 'English',
                  leading: Icon(FontAwesomeIcons.mehBlank),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReviewScreen(userUid: user.uid)));
                  },
                ),
                SettingsTile(
                  title: 'Sign Out',
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    await auth.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
