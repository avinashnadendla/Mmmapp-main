import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmmapp/Models/assignment.dart';
import 'package:mmmapp/bloc/AssignmentEvent.dart';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class AssignmentBloc extends Bloc {
  List<Assignment> _allAssignment;
  List<Assignment> get allAssignment => _allAssignment;

  StreamController<List<Assignment>> _assignDataController =
      StreamController<List<Assignment>>.broadcast();

  StreamSink<List<Assignment>> get assignDataSink => _assignDataController.sink;

  Stream<List<Assignment>> get assignDataStream => _assignDataController.stream;

  StreamController<AssignmentEvent> _assignEventController =
      StreamController<AssignmentEvent>.broadcast();

  StreamSink<AssignmentEvent> get assignEventSink =>
      _assignEventController.sink;

  Stream<AssignmentEvent> get _assignEventStream =>
      _assignEventController.stream;

  AssignmentBloc() {
    _assignEventStream.listen(mapEventToState);
  }
  Future<void> mapEventToState(AssignmentEvent event) async {
    if (event is AddAssignment) {
    } else if (event is FetchAssignment) {
      FirebaseFirestore.instance
          .collection("Projects")
          .snapshots()
          .listen((snapshot) {
        _allAssignment = List<Assignment>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allAssignment.add(Assignment.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        assignDataSink.add(_allAssignment);
      });
    }
  }

  @override
  void dispose() {
    _assignDataController.close();
    _assignEventController.close();
  }
}
