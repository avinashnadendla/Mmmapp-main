import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Models/chat.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ChatBloc extends Bloc {
  String downloadUrl;
  String id;
  List<Chat> _allChats;
  List<Chat> get allChats => _allChats;
  List<GroupPeople> _allGroups;
  List<GroupPeople> get allGroups => _allGroups;
  List<User> _allChatUsers;
  List<User> get allChatUsers => _allChatUsers;
  StreamController<List<User>> _userDataController =
      StreamController<List<User>>.broadcast();

  StreamSink<List<User>> get userDataSink => _userDataController.sink;

  Stream<List<User>> get userDataStream => _userDataController.stream;
  StreamController<List<GroupPeople>> _groupDataController =
      StreamController<List<GroupPeople>>.broadcast();

  StreamSink<List<GroupPeople>> get groupDataSink => _groupDataController.sink;

  Stream<List<GroupPeople>> get groupDataStream => _groupDataController.stream;

  StreamController<ChatEvent> _chatEventController =
      StreamController<ChatEvent>.broadcast();

  StreamSink<ChatEvent> get chatEventSink => _chatEventController.sink;

  Stream<ChatEvent> get _chatEventStream => _chatEventController.stream;

  StreamController<List<Chat>> _chatDataController =
      StreamController<List<Chat>>.broadcast();

  StreamSink<List<Chat>> get chatDataSink => _chatDataController.sink;

  Stream<List<Chat>> get chatDataStream => _chatDataController.stream;

  ChatBloc() {
    _chatEventStream.listen(mapEventToState);
  }
  Future<void> mapEventToState(ChatEvent event) async {
    if (event is AddChat) {

      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.userId)
          .collection(event.receiverId)
          .doc()
          .set(event.chat.toJson());

    } else if (event is AddChatUsers) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.senderId)
          .collection("ChatUsers")
          .doc(event.recieverId)
          .set(event.user.toJson(event.recieverId));
    } else if (event is AddGroups) {
      StorageReference storageReference = FirebaseStorage.instance.ref();
      StorageReference ref = storageReference.child("users/");
      StorageUploadTask storageUploadTask = ref.putFile(File(event.file.path));

      if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
        final String url = await ref.getDownloadURL();
        print("The download URL is " + url);
      } else if (storageUploadTask.isInProgress) {
        storageUploadTask.events.listen((event) {
          double percentage = 100 *
              (event.snapshot.bytesTransferred.toDouble() /
                  event.snapshot.totalByteCount.toDouble());
          print("THe percentage " + percentage.toString());
        });

        StorageTaskSnapshot storageTaskSnapshot =
            await storageUploadTask.onComplete;
        downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        print("Download URL " + downloadUrl.toString());
      }
      //Catch any cases here that might come up like canceled, interrupted
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Groups").doc();

      docRef.set({"photoPath": downloadUrl, "docId": docRef.id});

      FirebaseFirestore.instance
          .collection("Groups")
          .doc(docRef.id)
          .update({"groupUsers": event.groupPeople.groupUsers});
      FirebaseFirestore.instance
          .collection("Groups")
          .doc(docRef.id)
          .update({"usersId": event.groupPeople.usersID});
      docRef.update({"groupName": event.groupPeople.groupName});
      docRef.update({"date": event.groupPeople.date});
    } else if (event is AddGroupChats) {
      FirebaseFirestore.instance
          .collection("Groups")
          .doc(event.uid)
          .collection("groupchats")
          .doc()
          .set(event.chat.toJson());
    } else if (event is FetchChats) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.senderId)
          .collection(event.receiverId).orderBy('date')
          .snapshots()
          .listen((snapshot) {
        _allChats = List<Chat>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChats.add(Chat.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        chatDataSink.add(_allChats);
      });
    } else if (event is FetchGroups) {
      FirebaseFirestore.instance
          .collection("Groups")
          .snapshots()
          .listen((snapshot) {
        _allGroups = List<GroupPeople>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allGroups.add(GroupPeople.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        groupDataSink.add(_allGroups);
      });
    } else if (event is FetchGroupChats) {
      FirebaseFirestore.instance
          .collection("Groups")
          .doc(event.docId)
          .collection("groupchats")
          .orderBy('date')
          .snapshots()
          .listen((snapshot) {
        _allChats = List<Chat>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChats.add(Chat.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        chatDataSink.add(_allChats);
      });
    } else if (event is FetchChatUsers) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.userID)
          .collection("ChatUsers").orderBy('date')
          .snapshots()
          .listen((snapshot) {
        _allChatUsers = List<User>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChatUsers.add(User.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        userDataSink.add(_allChatUsers);
      });
    }
  }

  @override
  void dispose() {
    _chatEventController.close();
    _chatDataController.close();
    _groupDataController.close();
    _userDataController.close();
  }
}
