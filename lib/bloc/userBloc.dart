import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/bloc/userEvent.dart';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc extends Bloc {
  String downloadUrl;
  String id;
  List<User> _allUsers;
  List<User> get allUsers => _allUsers;
  StreamController<UserEvent> _userEventController =
      StreamController<UserEvent>.broadcast();

  StreamSink<UserEvent> get userEventSink => _userEventController.sink;

  Stream<UserEvent> get _userEventStream => _userEventController.stream;

  StreamController<List<User>> _userDataController =
      StreamController<List<User>>.broadcast();

  StreamSink<List<User>> get userDataSink => _userDataController.sink;

  Stream<List<User>> get userDataStream => _userDataController.stream;
  StreamController<User> _currentUserDataController =
      StreamController<User>.broadcast();

  StreamSink<User> get currentUserDataSink => _currentUserDataController.sink;

  Stream<User> get currentUserDataStream => _currentUserDataController.stream;

  UserBloc() {
    _userEventStream.listen(mapEventToState);
  }
  Future<void> mapEventToState(UserEvent event) async {
    if (event is AddUser) {
      StorageReference storageReference = FirebaseStorage.instance.ref();
      StorageReference ref = storageReference.child("users/");
      StorageUploadTask storageUploadTask =
          ref.putFile(File(event.file.path));

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

      FirebaseFirestore.instance
          .collection("users")
          .doc(event.user.userId)
          .set({"photoPath": downloadUrl});
      FirebaseFirestore.instance
          .collection("users")
          .doc(event.user.userId)
          .update(event.user.toJson(event.user.userId));

//      DocumentReference ref = await FirebaseFirestore.instance.collection("users").add({
//        "userId": "",
//      });
      /*  await FirebaseFirestore.instance
          .collection("users")
          .doc(event.user.userId)
          .set(event.user.toJson(event.user.userId), SetOptions(merge: true));*/
    } else if (event is FetchAllUser) {
      FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .listen((snapshot) {
        _allUsers = List<User>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allUsers.add(User.fromMap(snapshot.docs[i].data()));
        }
        print("All users:${_allUsers.length}");
        userDataSink.add(_allUsers);
      });
    } else if (event is FetchUser) {
      final snapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(event.userID)
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.
        User user = User(userId: "None");
        currentUserDataSink.add(user);
      } else {
        print("UID:" + event.userID);
        currentUserDataSink.add(User.fromMap(snapShot.data()));
      }
    }
  }

  @override
  void dispose() {
    _userEventController.close();
    _userDataController.close();
    _currentUserDataController.close();
  }
}
