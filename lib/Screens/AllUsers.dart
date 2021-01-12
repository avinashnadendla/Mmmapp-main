import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Screens/Groups/AddGroup.dart';
import 'package:mmmapp/Screens/chatRoom.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:search_page/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AllUsers extends StatefulWidget {
  final User user;
  AllUsers({this.user});
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  UserBloc _userBloc;
  ChatBloc _chatBloc;
  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _userBloc.userEventSink.add(FetchAllUser());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("All Contacts",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),

          // centerTitle: true,
        ),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent),
          Positioned(
              top: 70.0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width)),
          Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                onTap: () => displaySearch(),
                decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.filter_list),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0)),
              )),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 100.0,
              ),
              child: ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text("New Group"),
                  onTap: () {
                    if (widget.user.userType == "Admin") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGroup(
                                    user: widget.user,
                                  )));
                    } else {
                      print("not authosrised");
                    }
                  })),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 150.0,
              ),
              child: StreamBuilder<List<User>>(
                  stream: _userBloc.userDataStream,
                  initialData: _userBloc.allUsers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error"),
                        );
                      } else {
                        return Scrollbar(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                      title: Text(
                                        snapshot.data[i].name == null
                                            ? ""
                                            : "${snapshot.data[i].name[0].toUpperCase()}${snapshot.data[i].name.substring(1)}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            if (snapshot.data[i].userType ==
                                                "Admin") {
                                                   User receiver = User(
                                                  name: snapshot.data[i].name,
                                                  userId:
                                                      snapshot.data[i].userId);
                                                       User sender = User(
                                                  name: widget.user.name,
                                                  userId:
                                                      auth.FirebaseAuth.instance.currentUser.uid);
                                                      


                                              _chatBloc.chatEventSink.add(
                                                  AddChatUsers(
                                                      user: sender,
                                                      senderId: snapshot.data[i].userId,
                                                      recieverId: auth.FirebaseAuth.instance.currentUser.uid
                                                      ));
                                                        _chatBloc.chatEventSink.add(
                                                  AddChatUsers(
                                                      user: receiver,
                                                      senderId: auth.FirebaseAuth.instance.currentUser.uid,
                                                      recieverId: snapshot.data[i].userId
                                                      ));

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatRoom(
                                                            user: widget
                                                                .user.userId,
                                                            receiver: snapshot
                                                                .data[i],
                                                          )));
                                            } else if (widget.user.userType ==
                                                "Admin") {
                                              User receiver = User(
                                                  name: snapshot.data[i].name,
                                                  userId:
                                                      snapshot.data[i].userId);
                                                       User sender = User(
                                                  name: widget.user.name,
                                                  userId:
                                                      auth.FirebaseAuth.instance.currentUser.uid);
                                                      


                                              _chatBloc.chatEventSink.add(
                                                  AddChatUsers(
                                                      user: sender,
                                                      senderId: snapshot.data[i].userId,
                                                      recieverId: auth.FirebaseAuth.instance.currentUser.uid
                                                      ));
                                                        _chatBloc.chatEventSink.add(
                                                  AddChatUsers(
                                                      user: receiver,
                                                      senderId: auth.FirebaseAuth.instance.currentUser.uid,
                                                      recieverId: snapshot.data[i].userId
                                                      ));


                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatRoom(
                                                            user: widget
                                                                .user.name,
                                                            receiver: snapshot
                                                                .data[i],
                                                          )));
                                            } else {
                                              print("nothin");
                                            }
                                          }),
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[i].photoPath)));
                                }));
                      }
                    } else {
                      return Container(
                        child: Text(""),
                      );
                    }
                  }))
        ]));
  }

  void displaySearch() async {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    showSearch(
        context: context,
        delegate: SearchPage<User>(
            items: userBloc.allUsers,
            searchLabel: 'Search Person',
            suggestion: Center(
              child: Text('Filter Person by name'),
            ),
            failure: Center(
              child: Text('No Person found :('),
            ),
            filter: (person) => [
                  person.name,
                ],
            builder: (person) => ListTile(
                title: Text(
                  person.name == null
                      ? ""
                      : "${person.name[0].toUpperCase()}${person.name.substring(1)}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                trailing: IconButton(icon: Icon(Icons.send), onPressed: () {}),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        person.photoPath == null ? "" : person.photoPath)))));
  }
}

