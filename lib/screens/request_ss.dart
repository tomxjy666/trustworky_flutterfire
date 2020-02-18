import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';

class RequestSimpleServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: new Text("Simple Services",
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
                                RequestScreen(category: "General Services")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.seedling,
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
                "General Services",
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
                                RequestScreen(category: "Cleaning")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.broom,
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
                "Cleaning",
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
                                RequestScreen(category: "Delivery")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.truck,
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
                "Delivery",
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
                                RequestScreen(category: "Movers")));
                },
                child: ClipOval(
                  child: Container(
                      child: new Icon(
                        FontAwesomeIcons.peopleCarry,
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
                "Movers",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ))
        ],
      ),
    );
  }
}
