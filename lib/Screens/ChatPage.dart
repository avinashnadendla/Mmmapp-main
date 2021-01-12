import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Screens/chatRoom.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ChatPage extends StatefulWidget {
  final User user;
  ChatPage({this.user});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc _chatBloc;
  @override
  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.chatEventSink.add(
        FetchChatUsers(userID: auth.FirebaseAuth.instance.currentUser.uid));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: StreamBuilder<List<User>>(
                stream: _chatBloc.userDataStream,
                initialData: _chatBloc.allChatUsers,
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
                                return GestureDetector(
                                  child: ListTile(
                                      title: Text(
                                        snapshot.data[i].name == null
                                            ? ""
                                            : "${snapshot.data[i].name[0].toUpperCase()}${snapshot.data[i].name.substring(1)}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[i].photoPath == null
                                                  ? ""
                                                  : snapshot
                                                      .data[i].photoPath))),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                  user: snapshot.data[i].userId,
                                                  receiver: snapshot.data[i],
                                                )));
                                  },
                                );
                              }));
                    }
                  } else {
                    return Container(
                      child: Text(""),
                    );
                  }
                })));
  }
}
