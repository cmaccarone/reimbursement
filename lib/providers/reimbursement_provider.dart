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

  void approveReimbursement(int indexOf) async {
    QuerySnapshot pendingApprovalList;
    _firestore.runTransaction((transaction) async {
      //adds reimbursement object to the pendingReimbursement list for treasury staff.
      await transaction.set(
          _firestore.collection(Collections.pendingReimbursement).document(), {
        ReimbursementFields.dateSubmitted: _pendingApproval[indexOf].submitted,
        ReimbursementFields.dateReimbursed: null,
        ReimbursementFields.submittedBy: _pendingApproval[indexOf].reimburseTo,
        ReimbursementFields.amount: _pendingApproval[indexOf].amount
      });

      //adds the reimbursement to the user pending reimbursement list.
      await transaction.set(
          _firestore.collection(Collections.users).document(_currentUser.uid).collection(Collections.pendingReimbursement).document(), {
        ReimbursementFields.dateSubmitted: _pendingApproval[indexOf].submitted,
        ReimbursementFields.dateReimbursed: null,
        ReimbursementFields.submittedBy: _pendingApproval[indexOf].reimburseTo,
        ReimbursementFields.amount: _pendingApproval[indexOf].amount
      });
      //todo(Caleb): Remove from the Admin Request Approval list and the User request Approval List.
      transaction.get(_firestore.collection(Collections.pendingApproval).document()).then((snapshot){
        snapshot.data[]
      });
      transaction.delete(documentReference)
    });
    //move from pending approval collection to pendingreimbursement.
  }

  void requestApproval(Reimbursement reimbursement) async {
    //function adds data to users pending approval list and the Admin pending approval list atomicly.
    try {
      await _firestore.runTransaction((transaction) async {
        this._currentUser = await _auth.currentUser();
        //adds reimbursement to admin pending approval list.
        await transaction.set(
            _firestore.collection(Collections.pendingApproval).document(), {
          ReimbursementFields.dateSubmitted: DateTime.now(),
          ReimbursementFields.dateReimbursed: null,
          ReimbursementFields.submittedBy: _currentUser.email,
          ReimbursementFields.amount: reimbursement.amount
        });
        //adds reimbursement to user pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.users)
                .document(_currentUser.uid)
                .collection(Collections.pendingApproval)
                .document(),
            {
              ReimbursementFields.dateSubmitted: DateTime.now(),
              ReimbursementFields.dateReimbursed: null,
              ReimbursementFields.submittedBy: _currentUser.email,
              ReimbursementFields.amount: reimbursement.amount
            });
      });
    } catch (e) {
      print(e);
    }
  }

  // this funtion is to be used by admin users only.
  void getPendingApprovalReimbursements() async {
    var userType;
    Reimbursement reimbursement;
    _currentUser = await _auth.currentUser();
    var snapshot = await _firestore
        .collection(Collections.users)
        .document('${_currentUser.uid}')
        .get();
    userType = snapshot.data[UserFields.userType] ?? "userType";
    if (userType == "admin") {
      var snapshots = await _firestore
          .collection(Collections.pendingApproval)
          .orderBy(ReimbursementFields.dateSubmitted)
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

  void reimburse(int indexOf) {
    //remove from pendingApprovalReimbursements
    //add to pendingReimbursementList and move from
    _reimbursed.add(_pendingReimbursements[indexOf]);
    _pendingReimbursements.removeAt(indexOf);
    notifyListeners();
  }

  void removePendingReimbursement(int indexOf) {
    _pendingReimbursements.removeAt(indexOf);
    notifyListeners();
  }

  void removeReimbursementPendingApproval(int indexOf) {
    _pendingApproval.removeAt(indexOf);
    notifyListeners();
  }

  void createReimbursementInFirebase() async {
    try {
      var path = _firestore.collection(Collections.pendingReimbursement);

      await path.add(
        {},
      );
    } catch (e) {
      print(e);
    }
  }
}
