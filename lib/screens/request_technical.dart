import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';

class RequestTechnicalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: new Text("Technical",
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
                                RequestScreen(category: "Electrician")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.bolt,
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
                "Electrician",
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
                                RequestScreen(category: "Aircon")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.wind,
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
                "Aircon",
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
                                RequestScreen(category: "Plumber")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.wrench,
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
                "Plumber",
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
                                RequestScreen(category: "Car Mechanic")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.car,
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
                "Car Mechanic",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              
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
                                RequestScreen(category: "Locksmith")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.unlockAlt,
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
                "Locksmith",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              
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
                                RequestScreen(category: "Others")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.desktop,
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
                "Others",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              
            ],
          ))
        ],
      ),
    );
  }
}
