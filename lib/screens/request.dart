import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trustworky_flutterfire/services/services.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  final String category;

  RequestScreen({Key key, @required this.category}) : super(key: key);
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  RequestService req = RequestService();

  // String formCategory = '';
  String location = '';
  String compensation = '';
  String description = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
            title: Text(
              widget.category,
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
                                hintStyle: TextStyle(color: Colors.grey),
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[700])),
                                labelText: 'Location',
                                labelStyle: TextStyle(color: Colors.grey[700])),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please input location';
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
                                prefixText: 'S\$',
                                // hintText: 'S\$',
                                hintStyle: TextStyle(color: Colors.grey),
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[700])),
                                labelText: 'Compensation',
                                labelStyle: TextStyle(color: Colors.grey[700])),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please input compensation';
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
                            minLines: 1,
                            maxLines: 8,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                hintText: 'Input specifics of request',
                                hintStyle: TextStyle(color: Colors.grey),
                                focusColor: Colors.green,
                                fillColor: Colors.green,
                                hoverColor: Colors.green,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green[100])),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[700])),
                                labelText: 'Description',
                                labelStyle: TextStyle(color: Colors.grey[700])),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please input description of request';
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
                                  dynamic requestFormData =
                                      await req.updateRequestData(
                                          user,
                                          widget.category,
                                          location,
                                          compensation,
                                          description);
                                  // If the form is valid, display a Snackbar.
                                  if (requestFormData == null) {
                                    setState(() {
                                      error = 'submit fail';
                                    });
                                  }
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text('Request is being processed.')));
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/loggedin', (_) => false);
                                }
                              },
                              color: Colors.green,
                              label: Text(
                                'COMPLETE REQUEST',
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
