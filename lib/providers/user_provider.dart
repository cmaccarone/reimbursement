import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/model/databaseFields.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  FirebaseUser currentUser;
  String email;
  String payMeBy;
  String address;
  String zipCode;
  String state;
  String city;
  String userType;

  void getUser() async {
    currentUser = await _auth.currentUser();
  }

  void getUserDataOnLogin() async {
    await getUser();
    final data = await _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .get();
    print(data.data);
    payMeBy = data.data[UserFields.payMeBy];
    email = data.data[UserFields.email];
    address = data.data[UserFields.address];
    city = data.data[UserFields.city];
    state = data.data[UserFields.state];
    zipCode = data.data[UserFields.zipCode];
    userType = data.data[UserFields.userType];
    notifyListeners();
  }

  void registerUser(
      {String payMeBy,
      String address,
      String zipCode,
      String state,
      String city,
      String userType,
      String email}) async {
    //load property values
    this.address = address;
    this.zipCode = zipCode;
    this.state = state;
    this.city = city;
    this.userType = userType;
    this.email = email;

    try {
      getUser();
      var path = _firestore
          .collection(Collections.users)
          .document('${currentUser.uid}');
      await path.setData({
        UserFields.address: address,
        UserFields.city: city,
        UserFields.state: state,
        UserFields.zipCode: zipCode,
        UserFields.payMeBy: payMeBy,
        UserFields.userType: 'office',
        UserFields.email: email
      }, merge: true);
    } catch (e) {
      print(e);
    }
    notifyListeners();
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
