import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:mmmapp/Screens/AssingmentTab/CancelAssignment.dart';
import 'package:mmmapp/Screens/AssingmentTab/CompletedAssignment.dart';
import 'package:mmmapp/Screens/AssingmentTab/NewAssignment.dart';

class AssignmentHome extends StatefulWidget {
  @override
  _AssignmentHomeState createState() => _AssignmentHomeState();
}

class _AssignmentHomeState extends State<AssignmentHome> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: <Widget>[
        NewAssignment(),
        CompletedAssignment(),
        CancelAssignment(),
      ][currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.event),
            title: Text('New'),
            activeColor: Colors.deepPurple,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.done),
            title: Text('Completed'),
            activeColor: Colors.deepPurple,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.cancel),
            title: Text('Cancel'),
            activeColor: Colors.deepPurple,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
