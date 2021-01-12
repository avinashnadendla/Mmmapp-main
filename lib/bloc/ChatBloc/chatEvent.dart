import 'dart:io';

import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Models/chat.dart';

abstract class ChatEvent {}

class AddChat extends ChatEvent {
  final Chat chat;
  final String userId;
  final String receiverId;
  AddChat({this.chat, this.userId, this.receiverId});
}

class AddChatUsers extends ChatEvent {
  final User user;
  final String recieverId;
  final String senderId;
  AddChatUsers({this.user, this.recieverId, this.senderId});
}

class FetchChats extends ChatEvent {
  final String senderId;
  final String receiverId;

  FetchChats({this.senderId, this.receiverId});
}

class FetchChatUsers extends ChatEvent {
  final String userID;

  FetchChatUsers({this.userID});
}

class AddGroups extends ChatEvent {
  final GroupPeople groupPeople;
  final File file;
  AddGroups({this.groupPeople, this.file});
}

class FetchGroups extends ChatEvent {}

class AddGroupChats extends ChatEvent {
  final String uid;
  final Chat chat;
  AddGroupChats({this.uid, this.chat});
}

class FetchGroupChats extends ChatEvent {
  final String docId;
  FetchGroupChats({this.docId});
}
