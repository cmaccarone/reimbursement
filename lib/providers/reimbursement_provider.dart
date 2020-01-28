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

  void approveReimbursement(int indexOf) {
    _pendingReimbursements.add(_pendingApproval[indexOf]);
    _pendingApproval.removeAt(indexOf);
    notifyListeners();
    //todo add push notification reimbursement approved.
    //move from pending approval collection to pendingreimbursement.
  }

  void requestApproval(Reimbursement reimbursement) async {
    //adds reimbursement to admin pending approval list.
    try {
      _currentUser = await _auth.currentUser();
      await _firestore.collection(Collections.pendingApproval).add({
        ReimbursementFields.dateSubmitted: DateTime.now(),
        ReimbursementFields.dateReimbursed: null,
        ReimbursementFields.submittedBy: _currentUser.email,
        ReimbursementFields.amount: reimbursement.amount
      });
    } catch (e) {
      print(e);
    }
    //adds reimbursement to user pending approval list.
    try {
      _currentUser = await _auth.currentUser();
      await _firestore.collection(Collections.pendingApproval).add({
        ReimbursementFields.dateSubmitted: DateTime.now(),
        ReimbursementFields.dateReimbursed: null,
        ReimbursementFields.submittedBy: _currentUser.email,
        ReimbursementFields.amount: reimbursement.amount
      });
    } catch (e) {
      print(e);
    }
    //create a new reimbursement Object and add it to firebase
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
