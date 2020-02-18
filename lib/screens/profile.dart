import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustworky_flutterfire/screens/friendrequests.dart';
import 'package:trustworky_flutterfire/screens/publicProfileChat.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService auth = AuthService();
  String barcode = "";
  @override
  void initState() {
    super.initState();
  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan().then(
        (result) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PublicProfileChatScreen(userUid: result)))
      );
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
  

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
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyQrCodeScreen(user: user)));
              },
            ),
            new IconButton(
              icon: new Icon(FontAwesomeIcons.expand, color: Colors.black),
              onPressed: scan,
            ),
            // new Text(barcode, style: TextStyle(color: Colors.black),),
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
                                PublicProfileChatScreen(userUid: user.uid)));
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
                  title: 'My Friends',
                  // subtitle: 'English',
                  leading: Icon(FontAwesomeIcons.users),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FriendListScreen(userUid: user.uid)));
                  },
                ),
                SettingsTile(
                title: 'Friend Requests',
                subtitle: 'Approve or ignore requests',
                leading: Icon(Icons.group_add),
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FriendRequestScreen(userUid: user.uid)));
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
