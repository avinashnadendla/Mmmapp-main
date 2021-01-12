import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/Screens/Groups/NewGroup.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:search_page/search_page.dart';

class AddGroup extends StatefulWidget {
  final User user;
  AddGroup({this.user});
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<String> userlists = [];
  List<String> userIdLists = [];

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
      appBar: AppBar(
        title: Container(
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
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 50.0,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: userlists.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        userlists[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      userlists.removeAt(i);
                    });
                    print("deleted");
                  },
                );
              },
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
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
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
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
                                      onTap: () {
                                      bool check=  userlists.contains(snapshot.data[i].name);
                                        if(check==true){
                                          print("cant add twice");
                                        }
                                        else{
                                        setState(() {
                                          userlists.add(snapshot.data[i].name);
                                          userIdLists
                                              .add(snapshot.data[i].userId);
                                        });}
                                      },
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[i].photoPath == null
                                                  ? ""
                                                  : snapshot
                                                      .data[i].photoPath)));
                                }));
                      }
                    } else {
                      return Container(
                        child: Text(""),
                      );
                    }
                  }))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewGroup(
                        userLists: userlists,
                        usersId: userIdLists,
                        user: widget.user,
                      )));
        },
      ),
    );
  }

  void displaySearch() async {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    showSearch(
        context: context,
        delegate: SearchPage<User>(
            items: userBloc.allUsers,
            searchLabel: 'Search People',
            suggestion: Center(
              child: Text('Filter People by name'),
            ),
            failure: Center(
              child: Text('No ParentingTips found :('),
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
