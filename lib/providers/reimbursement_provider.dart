import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/model/reimbursement.dart';

class ReimbursementProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser _currentUser;
  List<Reimbursement> _reimbursed;

  List<Reimbursement> _pendingApproval;

  List<Reimbursement> _pendingReimbursements;

  void approveReimbursement(Reimbursement reimbursement) async {
    _firestore.runTransaction((transaction) async {
      //adds reimbursement object to the pendingReimbursement list for treasury staff.
      await transaction.set(
          _firestore
              .collection(Collections.pendingReimbursement)
              .document(reimbursement.reimbursementID),
          reimbursement.toMap(reimbursement));
      //adds the reimbursement to the user pending reimbursement list.
      await transaction.set(
          _firestore
              .collection(Collections.users)
              .document(reimbursement.submittedByUUID)
              .collection(Collections.pendingReimbursement)
              .document(reimbursement.reimbursementID),
          reimbursement.toMap(reimbursement));
      //removes reimbursement from the admin pendingApproval list
      await transaction.delete(_firestore
          .collection(Collections.pendingApproval)
          .document(reimbursement.reimbursementID));
      //removes reimbursement from User pendingApproval list
      await transaction.delete(_firestore
          .collection(Collections.users)
          .document(reimbursement.submittedByUUID)
          .collection(Collections.pendingApproval)
          .document(reimbursement.reimbursementID));
    });
  }

  void requestApproval(Reimbursement reimbursement) async {
    //function adds data to users pending approval list and the Admin pending approval list atomicly.
    try {
      await _firestore.runTransaction((transaction) async {
        //adds reimbursement to admin pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.pendingApproval)
                .document(reimbursement.reimbursementID),
            reimbursement.toMap(reimbursement));
        //adds reimbursement to user pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.users)
                .document(reimbursement.submittedByUUID)
                .collection(Collections.pendingApproval)
                .document(reimbursement.reimbursementID),
            reimbursement.toMap(reimbursement));
      });
    } catch (e) {
      print(e);
    }
  }



  //this function should only be used by treasury staff.
  void reimburse(Reimbursement reimbursement) {
    _firestore.runTransaction((transaction) async {
      //add reimbursement to the reimbursed list for the user.
      await transaction.set(
          _firestore
              .collection(Collections.users)
              .document(reimbursement.submittedByUUID)
              .collection(Collections.reimbursed)
              .document(reimbursement.reimbursementID),
          reimbursement.toMap(reimbursement));
      //remove from the user pending Reimbursement list.
      await transaction.delete(_firestore
          .collection(Collections.users)
          .document(reimbursement.submittedByUUID)
          .collection(Collections.pendingReimbursement)
          .document(reimbursement.reimbursementID));
      //remove the reimbursement object from the treasury pendingReimbursement list
      await transaction.delete(_firestore
          .collection(Collections.pendingReimbursement)
          .document(reimbursement.reimbursementID));
    });
  }

  // this funtion is to be used by admin users only.
  void getPendingApprovalReimbursements() async {
    var userType;
    Reimbursement reimbursement;
    _currentUser = await _auth.currentUser();
    var snapshot = await _firestore
        .collection(Collections.users)
        .document(_currentUser.uid)
        .get();
    userType = snapshot.data[UserFields.userType] ?? "userType";
    if (userType == "admin") {
      var snapshots = await _firestore
          .collection(Collections.pendingApproval)
          .orderBy(ReimbursementFields.timeSubmitted)
          .snapshots();
      snapshots.forEach((item) {
        for (var snap in item.documents) {
          reimbursement = Reimbursement.fromSnapshot(snapshot: snap);
          _pendingApproval.add(reimbursement);
          notifyListeners();
        }
      });
    }
  }


  //only used by Users
  Stream<Reimbursement> getPendingApproval() async* {
    Reimbursement reimbursement;
    _currentUser = await _auth.currentUser();
    var snapshots = _firestore
        .collection(Collections.users)
        .document(_currentUser.uid)
        .collection(Collections.pendingApproval)
        .orderBy(ReimbursementFields.timeSubmitted)
        .snapshots();
    snapshots.forEach((item) {
      for (var snap in item.documents) {
        reimbursement = Reimbursement.fromSnapshot(snapshot: snap);
        _pendingApproval.add(reimbursement);
        notifyListeners();
      }
    });
  }


  //only used by users
  Stream<Reimbursement> getPendingReimbursement() async* {
    Reimbursement reimbursement;
    _currentUser = await _auth.currentUser();
    var snapshots = _firestore
        .collection(Collections.users)
        .document(_currentUser.uid)
        .collection(Collections.pendingReimbursement)
        .orderBy(ReimbursementFields.timeSubmitted)
        .snapshots();
    snapshots.forEach((item) {
      for (var snap in item.documents) {
        reimbursement = Reimbursement.fromSnapshot(snapshot: snap);
        _pendingReimbursements.add(reimbursement);
        notifyListeners();
      }
    });
  }

  //only used by users
  Stream<Reimbursement> getReimbursed() async* {
    Reimbursement reimbursement;
    _currentUser = await _auth.currentUser();
    var snapshots = _firestore
        .collection(Collections.users)
        .document(_currentUser.uid)
        .collection(Collections.reimbursed)
        .orderBy(ReimbursementFields.timeSubmitted)
        .snapshots();
    snapshots.forEach((item) {
      for (var snap in item.documents) {
        reimbursement = Reimbursement.fromSnapshot(snapshot: snap);
        _reimbursed.add(reimbursement);
        notifyListeners();
      }
    });
  }
}


