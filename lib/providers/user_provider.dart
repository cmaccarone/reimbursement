import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reimbursement/model/databaseFields.dart';

class UserProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  FirebaseUser currentUser;
  String firstName;
  String lastName;
  String email;
  String payMeBy;
  String address;
  String zipCode;
  String state;
  String city;

  /// use the User class and its properties to define the UserType in a structured way.
  /// ex. User.admin = "admin";
  String userType;

  String get fullName {
    return "$firstName $lastName";
  }

  Future<FirebaseUser> getUser() async {
    currentUser = await _auth.currentUser();
    return currentUser;
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
    firstName = data.data[UserFields.firstName];
    lastName = data.data[UserFields.lastName];
  }

  void registerUser(
      {String firstName,
      String lastName,
      String payMeBy,
      String address,
      String zipCode,
      String state,
      String city,
      String userType,
      String email}) async {
    //load property values
    this.firstName = firstName;
    this.lastName = lastName;
    this.address = address;
    this.zipCode = zipCode;
    this.state = state;
    this.city = city;
    this.userType = userType;
    this.email = email;
    this.payMeBy = payMeBy;

    try {
      await getUser();
      var path = _firestore
          .collection(Collections.users)
          .document('${currentUser.uid}');
      await path.setData({
        UserFields.address: address,
        UserFields.city: city,
        UserFields.state: state,
        UserFields.zipCode: zipCode,
        UserFields.payMeBy: payMeBy,
        UserFields.userType: Users.employee,
        UserFields.email: email,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName
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

class Users {
  static final String admin = "admin";
  static final String treasury = "treasury";
  static final String employee = "employee";
}
