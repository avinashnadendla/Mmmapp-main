import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Models/chat.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';

class GroupChatRoom extends StatefulWidget {
  final User user;
  final GroupPeople groupPeople;
  GroupChatRoom({this.groupPeople,this.user});
  @override
  _GroupChatRoomState createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  ChatBloc _chatBloc;
 TextEditingController messageEditingController = new TextEditingController();

 void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.chatEventSink.add(FetchGroupChats(docId: widget.groupPeople.docId ));
    super.didChangeDependencies();
  }
  @override

 Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text(widget.groupPeople.groupName),),
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
                      if( snapshot.data[i].sendBy==widget.user.name){
                      return MessageTile(message: snapshot.data[i].message, sendByMe: true,
                      name: snapshot.data[i].sendBy,);}
                      else{
                        return MessageTile(message: snapshot.data[i].message,
                         sendByMe: false,name: snapshot.data[i].sendBy,);
                      }
                     
                    }));}}
                    return Container(child: Text(""),);},),

            
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
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
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                         DateTime date = DateTime.now();
                        String formattedDate =
                            DateFormat('HH:mm \n EEE d MMM').format(date);


                     Chat chat=Chat(message:messageEditingController.text,date:formattedDate
                       ,sendBy:widget.user.name,
                     
                     );
                        _chatBloc.chatEventSink.add(AddGroupChats(chat:chat,
                        uid:widget.groupPeople.docId
                        ));
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
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
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
  final String name;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe,this.name});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff007EF4)
              ]
                  : [
                const Color(0xffff4081),
                const Color(0xffff4081)
              ],
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.bold)),
            Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
    

        ],)
       
      ),
    );
  }
}
