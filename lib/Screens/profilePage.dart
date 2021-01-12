import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user});
  final User user;
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double circleRadius = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
        ),
        body:
         Container(

          height: double.infinity,
          width: double.infinity,
          color: Colors.cyan[200],
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: circleRadius / 2.0,
                    ),

                    ///here we create space for the circle avatar to get ut of the box
                    child: Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: circleRadius / 2,
                              ),
                              Text(widget.user.name==null?"":
                                "${widget.user.name[0].toUpperCase()}${widget.user.name.substring(1)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: Colors.blueGrey),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          widget.user.email==null?"":widget.user.email,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height:15.0),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Gender',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          widget.user.gender==null?"":widget.user.gender,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height:15.0),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Mobile Number',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          widget.user.number==null?"":widget.user.number,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                   
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ),

                  ///Image Avatar
                  Container(
                    width: circleRadius,
                    height: circleRadius,
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
                      child: Center(
                        child: Container(
                          child:ClipOval(
                    
                            child: Image.network(widget.user.photoPath==null?"":widget.user.photoPath,
                            fit: BoxFit.contain,),
                          
                        ),)
                      ),
                    ),
                  ),
                 
                ],
              
              ),
            ),
          ]),
        ));
  }
}
