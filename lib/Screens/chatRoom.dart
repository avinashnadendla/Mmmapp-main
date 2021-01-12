import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmmapp/Models/chat.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String user;
  final User receiver;
  ChatRoom({this.receiver, this.user});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  var imageUrl="";
  ChatBloc _chatBloc;
  TextEditingController messageEditingController = new TextEditingController();
  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.chatEventSink.add(FetchChats(
        senderId: auth.FirebaseAuth.instance.currentUser.uid,
        receiverId: widget.receiver.userId));
    super.didChangeDependencies();
  }
  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
  String downloadUrl;
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;

    image = await _imagePicker.getImage(source: ImageSource.gallery);

    var file = File(image.path);
    if (image != null) {
      await _firebaseStorage
          .ref()
          .child(generateRandomString(10))
          .putFile(file).onComplete.then((value){
            print(value);
            value.ref.getDownloadURL().whenComplete(() => print('hello')).then((value) {
              print(value);
              downloadUrl=value;
              setState(() {
                imageUrl = downloadUrl;
              });
              DateTime now = DateTime.now();
              String date = DateFormat('kk:mm').format(now);
              print(date);
              Chat chat = Chat(
                  message: imageUrl,
                  date: date,
                  sendBy: auth.FirebaseAuth.instance.currentUser.uid,
                  type: 'image'
              );
              _chatBloc.chatEventSink.add(AddChat(
                  chat: chat,
                  userId: auth.FirebaseAuth.instance.currentUser.uid,
                  receiverId: widget.receiver.userId));

              _chatBloc.chatEventSink.add(AddChat(
                  chat: chat,
                  userId: widget.receiver.userId,
                  receiverId:
                  auth.FirebaseAuth.instance.currentUser.uid));
              messageEditingController.text = "";
            });
      });
      // var downloadUrl = await snapshot.ref.getDownloadURL();

    } else {
      print('No Image Path Received');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.name),
      ),
      body: Container(
        child: Stack(
          children: [
            StreamBuilder<List<Chat>>(
              stream: _chatBloc.chatDataStream,
              initialData: _chatBloc.allChats,
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
                              // String formattedDate =
                              if (snapshot.data[i].sendBy ==
                                  auth.FirebaseAuth.instance.currentUser.uid) {
                                return MessageTile(
                                  message: snapshot.data[i].message,
                                  sendByMe: true,
                                  time: snapshot.data[i].date,
                                  type: snapshot.data[i].type,
                                );
                              } else {
                                return MessageTile(
                                    message: snapshot.data[i].message,
                                    type: snapshot.data[i].type,
                                    sendByMe: false);
                              }
                            }));
                  }
                }

                return Container(
                  child: Text(""),
                );
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: uploadImage, child: Icon(Icons.image)),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      //style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        DateTime now = DateTime.now();
                        String date = DateFormat('yyyy-MM-dd – kk:mm').format(now);

                        Chat chat = Chat(
                            message: messageEditingController.text,
                            date: date,
                            sendBy: auth.FirebaseAuth.instance.currentUser.uid,
                            type: 'message'
                        );
                        _chatBloc.chatEventSink.add(AddChat(
                            chat: chat,
                            userId: auth.FirebaseAuth.instance.currentUser.uid,
                            receiverId: widget.receiver.userId));

                        _chatBloc.chatEventSink.add(AddChat(
                            chat: chat,
                            userId: widget.receiver.userId,
                            receiverId:
                                auth.FirebaseAuth.instance.currentUser.uid));

                        messageEditingController.clear();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.send)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String time;
  final String type;
  MessageTile({@required this.message, @required this.sendByMe, this.time,this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: type == 'message'?Container(
            margin: sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: sendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                gradient: LinearGradient(

                  colors: sendByMe
                      ? [const Color(0xff007EF4), const Color(0xff007EF4)]
                      : [const Color(0xffff4081), const Color(0xffff4081)],
                )),
            child: Column(
              children: [
                Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
                Text(time,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'OverpassRegular',
                    )),
              ],
            )) :Container(
          width: 250.0,
          height: 250.0,
          padding: EdgeInsets.only(
              left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
          alignment:
          sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(message), fit: BoxFit.fill)),
        ));
  }
}
