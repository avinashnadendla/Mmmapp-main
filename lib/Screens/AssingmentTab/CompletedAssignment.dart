import 'package:flutter/material.dart';
import 'package:mmmapp/Screens/ChatPage.dart';
import 'package:mmmapp/Screens/Groups/GroupPage.dart';

class CompletedAssignment extends StatefulWidget {
  @override
  _CompletedAssignmentState createState() => _CompletedAssignmentState();
}

class _CompletedAssignmentState extends State<CompletedAssignment> {
  @override
  Widget build(BuildContext context) {
    return
  DefaultTabController(
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

//

            bottom: TabBar(

                tabs: [
                  Tab(
                    child:AssignmentTabs("Accepted")
                  ),
                                    Tab(
                    child:AssignmentTabs("Completed")
                  ),
                            

                ]),
           
          ),
          body: TabBarView(children: [
            ChatPage(
            ),
            GroupPage(
            ),
           
          ]),
          
   ) );
        }
        Widget AssignmentTabs(String text){
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