import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/bug.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/model/tripApproval.dart';

import 'user_provider.dart';

//return 3 different streams.
//stream recieve the data,
//use object constructor to create new object from new data
// push the new object into some sort of list that can be used and analized.
// push the new data into a stream.
// need separate streams for trip approval list, trips, and pending reimbursements,
//also need to figure out how to get reimbursements since they will be nested in each trip.
//reimbursements for each trip will be mapped out and then displayed in the UI

class ReimbursementProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  /// use the User class and its properties to define the UserType in a structured way.
  /// ex. User.admin = "admin";
  String userType;
  FirebaseUser currentUser;
  List<Receipt> receipts;

  void dispose() {}

  BuildContext context;
  Stream<List<TripApproval>> _tripsStream;
  Stream<List<Receipt>> _receiptStream;
  double amount;
  Stream<List<TripApproval>> _pendingTripStream;
  Stream<List<Receipt>> _pendingReceiptsStream;
  Stream<List<TripApproval>> _completedTripsStream;

  //firebase streams
  ReimbursementProvider() {
    initStreams(context: context);
    //initialize PendingReimbursement Stream..
  }

  Stream<List<TripApproval>> get tripStream => _tripsStream;
  Stream<List<TripApproval>> get completedTripStream => _completedTripsStream;
  Stream<List<TripApproval>> get pendingTripStream => _pendingTripStream;
  Stream<List<Receipt>> get reimbursementStream => _receiptStream;
  Stream<List<Receipt>> get pendingReimbursementStream =>
      _pendingReceiptsStream;

  void initStreams({@required BuildContext context}) async {
    userType = Provider.of<UserProvider>(context, listen: false).userType;
    print(userType);
    currentUser = await _auth.currentUser();
    if (userType == Users.admin) {
      _startTripStream();
      _startReimbursementStream();
      _startCompletedTripStream();
      _startPendingTripStream();
    } else if (userType == Users.treasury) {
      _startTripStream();
      _startReimbursementStream();
      _startPendingReimbursementStream();
      _startCompletedTripStream();
    } else if (userType == Users.superUser) {
      _startTripStream();
      _startCompletedTripStream();
      _startReimbursementStream();
      _startPendingTripStream();
      _startPendingReimbursementStream();
    } else {
      _startTripStream();
      _startReimbursementStream();
      _startCompletedTripStream();
    }
  }

  void _startTripStream() {
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

  void _startReimbursementStream() {
    _receiptStream = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.reimbursements)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              Receipt reimbursement = Receipt.fromSnapshot(snapshot: doc);
              receipts.add(reimbursement);
              return reimbursement;
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  void _startPendingTripStream() {
    _pendingTripStream = _firestore
        .collection(Collections.unapprovedTrips)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              print(doc.data);
              return TripApproval.fromSnapshot(snapshotData: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  void _startPendingReimbursementStream() {
    _pendingReceiptsStream = _firestore
        .collection(Collections.reimbursements)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              return Receipt.fromSnapshot(snapshot: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  void _startCompletedTripStream() {
    _completedTripsStream = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.completedTrips)
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
  void approveTrips({List<TripApproval> tripApprovalList}) async {
    assert(tripApprovalList.length != 0);
    tripApprovalList.map((trip) {
      if (trip.approved == ApprovalState.approved) {
        return trip;
      } else {
        return null;
      }
    }).forEach((tripApproval) {
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
            .collection(Collections.unapprovedTrips)
            .document(tripApproval.id));
      });
    });
  }

  void approveOrDenyTrip({TripApproval tripApproval}) async {
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
          .collection(Collections.unapprovedTrips)
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
                .collection(Collections.unapprovedTrips)
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
      {@required Receipt reimbursement, @required TripApproval approvedTrip}) {
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

  //this moves the trip to the user's completed trips list.
  void completeApprovedTrip({TripApproval trip}) {
    _firestore.runTransaction((transaction) async {
      await transaction.delete(_firestore
          .collection(Collections.users)
          .document(trip.submittedByID)
          .collection(Collections.trips)
          .document(trip.id));

      await transaction.set(
          _firestore
              .collection(Collections.users)
              .document(trip.submittedByID)
              .collection(Collections.completedTrips)
              .document(trip.id),
          trip.toMap(trip));
    });
  }

//called if the user swipes to delete the trip while its still pending.
  void cancelPendingTrip({TripApproval trip}) {
    _firestore.runTransaction((transaction) async {
      await transaction.delete(_firestore
          .collection(Collections.users)
          .document(trip.submittedByID)
          .collection(Collections.trips)
          .document(trip.id));

      await transaction.delete(
          _firestore.collection(Collections.unapprovedTrips).document(trip.id));
    });
  }

  //reimburse pending reimbursement (TREASURY USERS ONLY)
  void reimburse(Receipt reimbursement) {
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

  ///Use this method to return all the reimbursements for a specific trip. When a user clicks on that trip.
  List<Receipt> getReimbursements({TripApproval forTrip}) {
    return receipts.where(
        (reimbursements) => reimbursements.tripApproval.id == forTrip.id);
  }

  //todo: Create function to check all reimbursement to see if the receipt has already been reimbursed.
  //todo: add a single ARRAY to the user database for quickly checking if the receipt was already reimbursed.
  //todo finish getTotalSpentForTrip (totaling all the receipts so far and returning value)
  double getTotalSpent({TripApproval onTrip}) {
    double total;
    receipts.map((reimbursement) {
      // reimbursement.
    });
  }

  void reportBug({Bug bug}) async {
    await _firestore
        .collection(Collections.bugs)
        .document(bug.id)
        .setData(bug.toMap(bug));
  }
  //todo: add function to deal with when someone completes a trip and finishes submitting all their reimbursements.
}
