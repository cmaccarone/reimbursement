import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/model/databaseFields.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  String currentUserEmail;
  String paymentMethod;
  String address;
  String zipCode;
  String state;
  String city;
  String userType;

  void updateData(
      {String payMeBy,
      String address,
      String zipCode,
      String state,
      String city,
      String userType,
      String email}) async {
    this.paymentMethod = payMeBy;
    this.address = address;
    this.zipCode = zipCode;
    this.state = state;
    this.city = city;
    this.userType = userType;
    this.currentUserEmail = email;
    await _addUserDataToFirebase(
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        reimbursementType: "Special Travel",
        email: email);
    notifyListeners();
  }

  void _addUserDataToFirebase(
      {String address,
      String city,
      String state,
      String zipCode,
      String reimbursementType,
      String email}) async {
    try {
      FirebaseUser currentUser = await _auth.currentUser();
      var path = _firestore
          .collection(Collections.users)
          .document('${currentUser.uid}');
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

enum PayMeBy { ach, check }

//enum UserType {
//  office,
//  teacher,
//  pastor,
//  adminTreasury,
//  adminMinisterial,
//  superAdmin,
//}

//todo: add a reminder for admin user to update the remuneration rate each year.

enum Departments {
  ministerial,
  SSL,
  Admin,
  Treasury,
  Education,
  Spanish,
  Evangelism,
}
