import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/routes.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Firestore firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser currentUser;

  String firstName;

  String lastName;

  String emailField;

  String passwordfield;

  String passwordfield2;

  String addressField;

  String stateField;

  String cityField;

  String zipCodeField;

  String reimbursementType;

  String userType = "employee";

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppbarColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.lightBlueAccent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                    tag: 'dollar',
                    child: CircleAvatar(
                      child: Icon(
                        Icons.attach_money,
                        size: 60,
                        color: Colors.white,
                      ),
                      radius: 40,
                      backgroundColor: Colors.greenAccent,
                    )),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Column(
                  children: <Widget>[
                    Text(
                      'Register',
                      style: kTitleStyle,
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                    )
                  ],
                )),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  inputLabel: 'First Name',
                  hideText: false,
                  onChanged: (newValue) {
                    firstName = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  inputLabel: 'Last Name',
                  hideText: false,
                  onChanged: (newValue) {
                    lastName = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  inputLabel: 'Email',
                  hideText: false,
                  onChanged: (newValue) {
                    emailField = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  inputLabel: 'Password',
                  hideText: true,
                  onChanged: (newValue) {
                    passwordfield = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  inputLabel: 'Confirm Password',
                  hideText: true,
                  onChanged: (newValue) {
                    passwordfield2 = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  hideText: false,
                  inputLabel: 'Address',
                  onChanged: (newValue) {
                    addressField = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  hideText: false,
                  inputLabel: 'City',
                  onChanged: (newValue) {
                    cityField = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  hideText: false,
                  inputLabel: 'State',
                  onChanged: (newValue) {
                    stateField = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInTextFields(
                  hideText: false,
                  inputLabel: 'Zip Code',
                  onChanged: (newValue) {
                    zipCodeField = newValue;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text('How would you like to be paid?'),
                Center(
                  child: RadioButtonGroup(
                      labels: <String>[
                        "Check",
                        "ACH",
                      ],
                      onSelected: (String selected) {
                        (selected == 'Check')
                            ? reimbursementType = 'check'
                            : reimbursementType = 'ach';
                      }),
                ),
                SubmitButton(
                    label: 'Login',
                    onTapped: () async {
                      print('$emailField and $passwordfield');
                      if ((passwordfield != null) &&
                          (emailField != null) &&
                          passwordfield == passwordfield2) {
                        try {
                          await _auth.createUserWithEmailAndPassword(
                              email: emailField, password: passwordfield);
                          currentUser = await _auth.currentUser();
                          //  Navigator.popAndPushNamed(context, Routes.submitReimbursement);
                        } catch (e) {
                          setState(() {
                            errorMessage = e.toString();
                          });
                          print(e);
                        }
//todo make sure we have user data before logging in

                        RegisterNewUser(context,
                            Provider.of<UserProvider>(context, listen: false));
                      }
                      if (passwordfield2 != passwordfield) {
                        setState(() {
                          errorMessage = "Password Fields Must Match";
                        });
                      }
                    }),
                SizedBox(
                  height: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void RegisterNewUser(BuildContext context, UserProvider user) async {
    user.registerUser(
        firstName: firstName,
        lastName: lastName,
        email: currentUser.email,
        payMeBy: reimbursementType,
        address: addressField,
        zipCode: zipCodeField,
        state: stateField,
        city: cityField,
        userType: userType);
    currentUser = await _auth.currentUser();

    Provider.of<ReimbursementProvider>(context, listen: false)
        .initStreams(context: context);
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushNamedAndRemoveUntil(context, Routes.mainTabBar, (_) => false);
  }
}
