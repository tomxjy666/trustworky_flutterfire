import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCodeScreen extends StatefulWidget {
  final user;
  MyQrCodeScreen({Key key, @required this.user}) : super(key: key);
  @override
  _MyQrCodeScreenState createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Qr Code'), backgroundColor: Colors.green),
      body: Center(
        child: QrImage(
          data: widget.user.uid,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
