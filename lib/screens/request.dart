import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  RequestService req = RequestService();

  String title = '';
  String location = '';
  String compensation = '';
  String description = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Request a Task',
              style: TextStyle(
                fontFamily: 'ProductSans',
                // fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white),
        body: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Builder(
                builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                title = val;
                              });
                            },
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                hintText: 'Use an eye catching title',
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                labelText: 'Title',
                                labelStyle: TextStyle(color: Colors.green)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                          ),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                location = val;
                              });
                            },
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                hintText: 'i.e. Singapore',
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                labelText: 'Location',
                                labelStyle: TextStyle(color: Colors.green)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                          ),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                compensation = val;
                              });
                            },
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                hintText: 'S\$',
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                labelText: 'Compensation',
                                labelStyle: TextStyle(color: Colors.green)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                          ),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                description = val;
                              });
                            },
                            minLines: 3,
                            maxLines: 8,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                hintText: 'Input specifics of request',
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                labelText: 'Description',
                                labelStyle: TextStyle(color: Colors.green)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton.icon(
                              icon: Icon(
                                Icons.call_made,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false
                                // otherwise.
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  dynamic requestFormData = await req.updateRequestData(user, title, location, compensation, description);
                                  // If the form is valid, display a Snackbar.
                                  if(requestFormData == null){
                                    setState(() {
                                      error = 'submit fail';
                                    });
                                  }
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: Text('Request is being processed.')));
                                }
                              },
                              color: Colors.green,
                              label: Text(
                                'SUBMIT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))));
  }
}
