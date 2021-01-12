import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Models/chat.dart';
import 'package:mmmapp/Screens/home.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewGroup extends StatefulWidget {
  final List<String> userLists;
  final List<String> usersId;
  final User user;
  NewGroup({this.user, this.userLists, this.usersId});
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  ChatBloc _chatBloc;

  @override
  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    super.didChangeDependencies();
  }

  TextEditingController textEditingController = TextEditingController();
  File _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("New group")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.0),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: _image == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 30.0,
                                    )
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
                          SizedBox(height: 15.0),
                          Container(
                              height: 40,
                              child: TextFormField(
                                controller: textEditingController,
                                decoration: InputDecoration(
                                    hintText: 'Please type group subject here'),
                                validator: (value) =>
                                    textEditingController.toString().isEmpty
                                        ? "Please add groupName"
                                        : "",
                              )),
                          SizedBox(height: 20.0),
                          Container(
                            child: Text(
                              "Participants",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.userLists.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Text(widget.userLists[i],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white)));
                                  })),
                          SizedBox(height: 20.0),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                              ),
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: FlatButton(
                                  onPressed: () async {
                                    if (_image == null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Alert!!'),
                                          content: Text('Pick Image .'),
                                          actions: <Widget>[
                                            GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pop(true),
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }

                                    if (!_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      widget.userLists.add(widget.user.name);
                                      widget.usersId.add(widget.user.userId);
                                      DateTime date = DateTime.now();

                                      String formattedDate =
                                          DateFormat('HH:mm \n EEE d MMM')
                                              .format(date);

                                      GroupPeople groupPeople = GroupPeople(
                                          date: formattedDate,
                                          groupName: textEditingController.text,
                                          groupUsers: widget.userLists,
                                          usersID: widget.usersId);

                                      _chatBloc.chatEventSink.add(AddGroups(
                                          groupPeople: groupPeople,
                                          file: _image));

                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                    user: widget.user,
                                                  )));
                                    } else {
                                      print("hello");
                                    }
                                  },
                                  child: Text(
                                    'create',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  )))
                        ])))));
  }
}
