import 'package:flutter/cupertino.dart';
import 'package:reimbursement/model/reimbursement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reimbursement/model/databaseFields.dart';

class ReimbursementProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  
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

  void requestApproval(Reimbursement reimbursement) {
    _pendingApproval.add(reimbursement);
    notifyListeners();
    //create a new reimbursement Object and add it to firebase
    
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
  
  void createReimbursementInFirebase()async{
    try {
      FirebaseUser currentUser = await _auth.currentUser();
      var path = _firestore
          .collection(Collections.pendingReimbursement);

      await path.setData({
        UserFields.address: address,
        UserFields.city: city,
        UserFields.state: state,
        UserFields.zipCode: zipCode,
        UserFields.payMeBy: reimbursementType,
        UserFields.userType: 'office',
        UserFields.email: email
      }, merge: true);
    } catch (e) {
      print(e);
    }
  }
}
