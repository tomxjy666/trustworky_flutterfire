import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';
class RequestAdhocScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: new Text("Adhoc",
              style: TextStyle(fontFamily: 'ProductSans', color: Colors.black)),
          backgroundColor: Colors.white),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequestScreen(category: "Part-Time")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.userClock,
                        color: Colors.green,
                      ),
                      color: Colors.grey[200],
                      height: 100.0,
                      width: 100.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Part-Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )),
          Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequestScreen(category: "Freelance")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.userTie,
                        color: Colors.green,
                      ),
                      color: Colors.grey[200],
                      height: 100.0,
                      width: 100.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Freelance",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ))
        ],
      ),
    );
  }
}
