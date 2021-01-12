import 'package:flutter/material.dart';
import 'package:mmmapp/Models/assignment.dart';

class AssignmentDetails extends StatefulWidget {
  final Assignment assignment;
  AssignmentDetails({this.assignment});
  @override
  _AssignmentDetailsState createState() => _AssignmentDetailsState();
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Assignment Details'),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(children: [
                  Container(
                      padding: EdgeInsets.only(top: 6.0),
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      color: Colors.deepPurple,
                      child: Text(
                        "${widget.assignment.title[0].toUpperCase()}${widget.assignment.title.substring(1)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Assignment-Id",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.id == null
                                  ? ""
                                  : widget.assignment.id,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Assignment-Type",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.assignmentType == null
                                  ? ""
                                  : widget.assignment.assignmentType,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Subject",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.subject == null
                                  ? ""
                                  : widget.assignment.subject,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                            Spacer()
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "DocumentType",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.docType == null
                                  ? ""
                                  : widget.assignment.docType,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Number Of Pages",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.noOFPages == null
                                  ? ""
                                  : widget.assignment.noOFPages.toString(),
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "English Level",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.engLevel == null
                                  ? ""
                                  : widget.assignment.engLevel,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Style",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.style == null
                                  ? ""
                                  : widget.assignment.style,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Deadline :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                              Spacer(),
                              Text(widget.assignment.deadline),
                            ]),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Upload Date :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                              Spacer(),
                              Text(widget.assignment.uploadDate),
                            ]),
                        SizedBox(height: 10.0),
                        Column(children: [
                          Text(
                            "Description :",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                widget.assignment.description == null
                                    ? ""
                                    : widget.assignment.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              )),
                        ]),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Co-Admin",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              widget.assignment.coAdmin == null
                                  ? ""
                                  : widget.assignment.coAdmin,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Tutor Payment",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              Text(
                                "Rs.${(widget.assignment.tutorPayment == null) ? "n/a" : widget.assignment.tutorPayment.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              ),
                            ]),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Note :",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  widget.assignment.additionalNotes == null
                                      ? ""
                                      : widget.assignment.additionalNotes,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black),
                                ))
                          ],
                        ),
                      ])),
                  Container(
                    padding: EdgeInsets.only(left: 50.0, right: 50.0),
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.lightBlue[700],
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'Apply Now',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]))));
  }

  Future<void> alert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              """
    sorry you can't register twice ?""",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0),
            ),
            actions: [
              FlatButton(
                child: Text("ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
