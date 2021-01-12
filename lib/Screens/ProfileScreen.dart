import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mmmapp/Screens/home.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final auth.User user;
  final User nuser;
  ProfileScreen({this.user, this.nuser});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _userBloc;
  User user;
  String radio = '';

  File _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";
  String _number = "";
  String _gender = "";

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Profile"),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(30.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: _image == null
                              ? Icon(Icons.add_a_photo)
                              : Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  name!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email-Id'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  Email!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _email = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Gender'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  Gender!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _gender = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Mobile Number'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  Mobile Number';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _number = value;
                        },
                      ),
                    ),
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.,
                        children: <Widget>[
                          RadioListTile(
                            groupValue: radio,
                            title: Text('Admin'),
                            value: 'Admin',
                            onChanged: (val) {
                              setState(() {
                                radio = val;
                              });
                            },
                          ),
                          RadioListTile(
                            groupValue: radio,
                            title: Text('Tutor'),
                            value: 'Tutor',
                            onChanged: (val) {
                              setState(() {
                                radio = val;
                              });
                            },
                          ),
                          RadioListTile(
                            groupValue: radio,
                            title: Text('Student'),
                            value: 'Student',
                            onChanged: (val) {
                              setState(() {
                                radio = val;
                              });
                            },
                          ),
                        ]),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: FlatButton(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_image == null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Alert!!'),
                                  content: Text('Pick Image .'),
                                  actions: <Widget>[
                                    GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pop(true),
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();

                            User newUser = User(
                                name: _name,
                                email: _email,

                                //photopath: _image.path,
                                userId: widget.user.uid,
                                number: _number,
                                gender: _gender,
                                userType: radio);
                            _userBloc.userEventSink
                                .add(AddUser(user: newUser, file: _image));
                            //Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen(
                                  user: widget.nuser,
                                );
                              },
                            ));
                          },
                        )),
                  ],
                ))));
  }
}
