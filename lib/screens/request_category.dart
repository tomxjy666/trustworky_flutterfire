import 'package:flutter/material.dart';
import 'package:trustworky_flutterfire/screens/screens.dart';

class RequestCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text("Make A Request",
              style: TextStyle(fontFamily: 'ProductSans', color: Colors.black)),
          backgroundColor: Colors.white),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 125,
              ),
              Text("Choose a category"),
              SizedBox(
                height: 25,
              ),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Simple Services",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RequestSimpleServiceScreen()));
                    },
                    color: Colors.grey[300],
                  )),
              SizedBox(
                height: 15,
              ),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Technical",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestTechnicalScreen()));
                    },
                    color: Colors.grey[300],
                  )),
              SizedBox(
                height: 15,
              ),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Adhoc",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestAdhocScreen()));
                    },
                    color: Colors.grey[300],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
