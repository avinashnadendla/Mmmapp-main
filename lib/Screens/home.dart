import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Screens/AllUsers.dart';
import 'package:mmmapp/Screens/AssingmentTab/AssignmentHome.dart';
import 'package:mmmapp/Screens/ChatPage.dart';
import 'package:mmmapp/Screens/ForumScreens/ForumPage.dart';
import 'package:mmmapp/Screens/Groups/GroupPage.dart';
import 'package:mmmapp/Screens/profilePage.dart';
import 'package:mmmapp/bloc/AuthenticationBloc/authbloc.dart';
import 'package:mmmapp/bloc/AuthenticationBloc/authevent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Authenticate/login_Screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:DefaultTabController(length: 
        2,child:
         Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: Text(
                  'Home',
                  textAlign: TextAlign.center,
                ),
              bottom: TabBar(
              
                tabs: [
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Chats",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Groups",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                 
                ]),
           
          ),
          body: TabBarView(children: [
            ChatPage(
              user: widget.user,
            ),
            GroupPage(
              user: widget.user,
            ),
           
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllUsers(
                            user: widget.user,
                          )));
            },
            child: Icon(Icons.search),
          ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 0.0, top: 10.0,right:170.0),
                    color: Colors.deepPurple,
                    height: 110.0,
                    child: Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child:
                     Container(
                          child: ClipOval(
                            child: Image.network(widget.user.photoPath==null?
                            "":widget.user.photoPath),
                          ),
                        
                  ),),),),
                  SizedBox(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    child: UserAccountsDrawerHeader(
                      accountName: 
                      Text(
              widget.user.name==null?"":widget.user.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
                      accountEmail: Text(widget.user.email==null?"":widget.user.email),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.home,
                      color: Colors.deepPurple,
                    ),
                    title: Text("Home"),
                    onTap: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            user: widget.user,
                          )));
            },


                  ),
                  ListTile(
                    leading: Icon(
                      Icons.assignment,
                      //FontAwesomeIcons.bookOpen,
                      color: Colors.deepPurple,
                    ),
                    title: Text("Assignments"),
                    onTap: () {
                                              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssignmentHome(
                          )));

                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.forum,
                      color: Colors.deepPurple,
                    ),
                    title: Text("Forum"),
                    onTap: () async {
                                                                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForumPage(
                          )));

                    },
                  ),
                   ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                    title: Text("Profile"),
                    onTap:(){
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        user: widget.user,
                          )));

                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.deepPurple,
                    ),
                    title: Text("Logout"),
                    onTap: (){

    
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLoggedOut());
                  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                  ),
                ],
              ),
            ),
            


            )));
           

  }
}
/*class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue[700],
            title: Center(
              child: Text(
                "Chatter",
                style: TextStyle(color: Colors.white),
              ),
            ),

//

            bottom: TabBar(
                /*     unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[300]
        ),*/
                tabs: [
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Chats",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Groups",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ]),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLoggedOut());
                },
              )
            ],
          ),
          body: TabBarView(children: [
            ChatPage(
              user: widget.user.name,
            ),
            GroupPage(
              user: widget.user,
            ),
            ProfilePage(
              user: widget.user,
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllUsers(
                            user: widget.user,
                          )));
            },
            child: Icon(Icons.search),
          ),
        ));
  }
}
*/
