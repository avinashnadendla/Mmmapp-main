import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Screens/Authenticate/login_Screen.dart';
import 'package:mmmapp/Screens/ProfileScreen.dart';
import 'package:mmmapp/Screens/home.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class RouteScreen extends StatefulWidget {
  final auth.User user;
  RouteScreen({this.user});
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var getUser = auth.FirebaseAuth.instance.currentUser;
    if (getUser != null) {
      _userBloc.mapEventToState(FetchUser(userID: getUser.uid));
      return StreamBuilder<User>(
          stream: _userBloc.currentUserDataStream,
          //                                        initdialData: _storeBloc.getInitialRateList,
          builder: (context, snapshot) {
            print("LOG_snapshot" + snapshot.data.toString());
            if (snapshot.hasData) {
              User userData = snapshot.data;
              if (userData.userId == "None") {
                return ProfileScreen(
                  user: widget.user,
                  nuser: userData,
                );
              }
              return HomeScreen(
                user: userData,
              );
            } else {
              return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                  backgroundColor: Colors.white);
            }
          });
    } else {
      print("myUID" + getUser.toString());
      //return SignInPage();
      return LoginScreen();
    }
  }
}
