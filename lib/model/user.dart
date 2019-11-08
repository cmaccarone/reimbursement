import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/reimbursement.dart';

class User extends ChangeNotifier {

  List<Reimbursement> _reimbursements;

  List<Reimbursement> _pendingReimbursements;

   String currentUserEmail;
   String paymentMethod;
   String address;
   String zipCode;
   String state;
   String city;
   String userType;

   void approveReimbursement(int indexOf){
     _reimbursements.add(_pendingReimbursements[indexOf]);
     _pendingReimbursements.removeAt(indexOf);
     notifyListeners();
     //todo add push notification reimbursement approved.
   }

   void requestReimbursement(Reimbursement reimbursement){
     _pendingReimbursements.add(reimbursement);
     notifyListeners();
   }

   void addReimbursement(Reimbursement reimbursement){
     _reimbursements.add(reimbursement);
     notifyListeners();
   }

   void removeReimbursement(int indexOf){
     _reimbursements.removeAt(indexOf);
     notifyListeners();
   }

  void updateData({String payMeBy,String address,String zipCode,String state,String city,String userType,String email}){
      this.paymentMethod = payMeBy;
      this.address = address;
      this.zipCode = zipCode;
      this.state = state;
      this.city = city;
      this.userType = userType;
      this.currentUserEmail = email;
      notifyListeners();
  }

}

enum PayMeBy {
  ach,
  check
}

//enum UserType {
//  office,
//  teacher,
//  pastor,
//  adminTreasury,
//  adminMinisterial,
//  superAdmin,
//}

enum Departments {
  ministerial,
  SSL,
  Admin,
  Treasury,
  Education,
  Spanish,
  Evangelism,
}