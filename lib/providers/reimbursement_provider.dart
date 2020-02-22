import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/model/reimbursement.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/util/list_stream.dart';

//return 3 different streams.
//stream recieve the data,
//use object constructor to create new object from new data
// push the new object into some sort of list that can be used and analized.
// push the new data into a stream.
// need separate streams for trip approval list, trips, and pending reimbursements,
//also need to figure out how to get reimbursements since they will be nested in each trip.
//reimbursements for each trip will be mapped out and then displayed in the UI
//todo imports
//todo list of data
//todo stream controllers
//todo stream sink getter
//todo constructor - add data listen to streams
//todo dispose
//todo core functions

class ReimbursementProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser currentUser;

  //lists

  List<Reimbursement> _userReimbursements = [];

  List<Reimbursement> _pendingReimbursements = [];

  List<TripApproval> _pendingApprovalTrips = [];

  List<TripApproval> _trips = [];

  void dispose() {}

  //External Stream Subs

  StreamSubscription<QuerySnapshot> _pendingReimbursementStream;
  StreamSubscription<QuerySnapshot> _userTripsStream;
  StreamSubscription<QuerySnapshot> _pendingTripsStream;
  StreamSubscription<QuerySnapshot> _userReimbursementStream;

  Stream<List<TripApproval>> _tripsStream;

  //internal Streams - output complex objects instead of raw data.
  ListStream<Reimbursement> pendReimbursement = ListStream();
  ListStream<TripApproval> tripStream = ListStream();
  ListStream<TripApproval> pendTripStream = ListStream();
  ListStream<Reimbursement> reimbursementStream = ListStream();

  //firebase streams
  ReimbursementProvider() {
    initStreams();
    //initialize PendingReimbursement Stream..
  }

  Stream<List<TripApproval>> get stream => _tripsStream;

  void initStreams() async {
    currentUser = await _auth.currentUser();
    print(currentUser.uid);

    //initilize User Trips Stream
    print("here");
    _tripsStream = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.trips)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              return TripApproval.fromSnapshot(snapshotData: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  //FOR ADMIN ONLY
  void approveTrip({TripApproval tripApproval}) async {
    _firestore.runTransaction((transaction) async {
      //Updates users trip status to approved (this happens in the UI) the new mutated trip is passed in as the new data to be updated.
      await transaction.update(
          _firestore
              .collection(Collections.users)
              .document(tripApproval.submittedByID)
              .collection(Collections.trips)
              .document(tripApproval.id),
          tripApproval.toMap(tripApproval));
      //removes reimbursement from the admin pendingApproval list
      await transaction.delete(_firestore
          .collection(Collections.pendingApproval)
          .document(tripApproval.id));
    });
  }

  //Requests approval for trip
  void requestApprovalForTrip({TripApproval tripApproval}) async {
    print("approval requested");
    //function adds data to users pending approval list and the Admin pending approval list atomicly.
    try {
      await _firestore.runTransaction((transaction) async {
        //adds reimbursement to admin pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.pendingApproval)
                .document(tripApproval.id),
            tripApproval.toMap(tripApproval));
        //adds reimbursement to user pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.users)
                .document(tripApproval.submittedByID)
                .collection(Collections.trips)
                .document(tripApproval.id),
            tripApproval.toMap(tripApproval));
      });
    } catch (e) {
      print(e);
    }
  }

  //Requests Reimbursement for a specific trip. (USERS)
  void requestReimbursement(
      {@required Reimbursement reimbursement,
      @required TripApproval approvedTrip}) {
    print("reimbursement requested");
    _firestore.runTransaction((transaction) async {
      //add reimbursement to the reimbursed list for the user.
      await transaction.set(
          _firestore
              .collection(Collections.users)
              .document(reimbursement.submittedByUUID)
              .collection(Collections.reimbursements)
              .document(reimbursement.reimbursementID),
          reimbursement.toMap(reimbursement));
      //add to the treasury pendingReimbursement list
      await transaction.set(
          _firestore
              .collection(Collections.pendingReimbursement)
              .document(reimbursement.reimbursementID),
          reimbursement.toMap(reimbursement));
    });
  }

  //reimburse pending reimbursement (TREASURY USERS ONLY)
  void reimburse(Reimbursement reimbursement) {
    _firestore.runTransaction((transaction) async {
      //add reimbursement to the reimbursed list for the user.
      await transaction.update(
          _firestore
              .collection(Collections.users)
              .document(reimbursement.submittedByUUID)
              .collection(Collections.reimbursements)
              .document(reimbursement.reimbursementID),
          reimbursement.toMap(reimbursement));
      //remove the reimbursement object from the treasury pendingReimbursement list
      await transaction.delete(_firestore
          .collection(Collections.pendingReimbursement)
          .document(reimbursement.reimbursementID));
    });
  }

  // Returns all the trip requests (FOR ADMIN USERS ONLY)
//  void getTripRequests(QuerySnapshot snapshot) async {
//
//    var userType;
//    TripApproval approval;
//    var snapshots = await _firestore
//        .collection(Collections.users)
//        .document(currentUser.uid)
//        .get();
//    userType = snapshots.data[UserFields.userType] ?? "userType";
//    if (userType == "admin") {
//      snapshot.documents.forEach((item) {
//          TripApproval.fromSnapshot(snapshotData: item);
//          _pendingApprovalTrips.add(approval);
//          pendingTripApprovals.sink.add(_pendingApprovalTrips);
//          notifyListeners();
//      });
//    }
//  }

//  //only used by users
//  Stream<TripApproval> getTrips() async* {
//    TripApproval trip;
//    _currentUser = await _auth.currentUser();
//    print("Email: ${_currentUser.email} id: ${_currentUser.uid}");
//   tripsStream.sink.addStream( _firestore
//        .collection(Collections.users)
//        .document(_currentUser.uid)
//        .collection(Collections.trips)
//        .snapshots());
//      for (var trip in tripsStream.) {
//        TripApproval newTrip = TripApproval.fromSnapshot(snapshotData: trip);
//         newTrip;
//      }
//
//  }

  //only used by users gets all the reimbursements for a specific trip.
  Future<List<Reimbursement>> getReimbursements(TripApproval forTrip) async {
    List<Reimbursement> reimbursements;

    var snapshots = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.reimbursements)
        .orderBy(ReimbursementFields.timeSubmitted)
        .snapshots();
    snapshots.forEach((item) {
      for (var snap in item.documents) {
        Reimbursement reimbursement =
            Reimbursement.fromSnapshot(snapshot: snap);
        if (reimbursement.tripApproval.id == forTrip.id) {
          reimbursements.add(reimbursement);
        }
      }
    });
    return reimbursements;
  }

  //todo: add function to deal with when someone completes a trip and finishes submitting all their reimbursements.
}
