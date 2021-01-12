import 'dart:io';

import 'package:mmmapp/Models/User.dart';

abstract class UserEvent {}

class AddUser extends UserEvent {
  final User user;
  final File file;
  AddUser({this.user, this.file});
}

class FetchUser extends UserEvent {
  final String userID;

  FetchUser({this.userID});
}

class FetchAllUser extends UserEvent {}
