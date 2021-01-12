import 'package:flutter/material.dart';
import 'package:mmmapp/Models/assignment.dart';
import 'package:mmmapp/Screens/AssingmentTab/AssignmentDetails.dart';
import 'package:mmmapp/Screens/ChatPage.dart';
import 'package:mmmapp/Screens/Groups/GroupPage.dart';
import 'package:mmmapp/bloc/AssignmentBloc.dart';
import 'package:mmmapp/bloc/AssignmentEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class NewAssignment extends StatefulWidget {
  @override
  _NewAssignmentState createState() => _NewAssignmentState();
}

class _NewAssignmentState extends State<NewAssignment> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                "Assignments",
                style: TextStyle(color: Colors.white),
              ),
            ),
            bottom: TabBar(tabs: [
              Tab(child: AssignmentTabs("New")),
              Tab(child: AssignmentTabs("Assigned")),
            ]),
          ),
          body: TabBarView(children: [
            NewAssignmentPage(),
            GroupPage(),
          ]),
        ));
  }

  Widget AssignmentTabs(String text) {
    return Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ));
  }
}
class NewAssignmentPage extends StatefulWidget {
  @override
  _NewAssignmentPageState createState() => _NewAssignmentPageState();
}

class _NewAssignmentPageState extends State<NewAssignmentPage> {
 
  void didChangeDependencies() {
    AssignmentBloc _assignmentBloc = BlocProvider.of<AssignmentBloc>(context);
    _assignmentBloc.assignEventSink.add(FetchAssignment());
    super.didChangeDependencies();
  }

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AssignmentBloc _assignmentBloc = BlocProvider.of<AssignmentBloc>(context);
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<Assignment>>(
        stream: _assignmentBloc.assignDataStream,
        initialData: _assignmentBloc.allAssignment,
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
                        return Container(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.event,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                title: Text(
                                  "${snapshot.data[i].title}",
                                  style: TextStyle(
                                    color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {


                                  
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                      AssignmentDetails(
                                                  assignment: snapshot.data[i],
                                                        )));}
                                 
                              ),
                            ));
                      
                    }),
              );
            }
          } else {
            return Center(
              child: Text("Assignment will be seen here!!",),
            );
          }
        },
      ),
    );
  }
}
