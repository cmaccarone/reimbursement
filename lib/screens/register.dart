import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/routes.dart';
import 'package:reimbursement/widgets.dart';

class RegisterScreen extends StatelessWidget {
  final Firestore firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  final TextEditingController controller = TextEditingController();
  String emailField;
  String passwordfield;
  String addressField;
  String stateField;
  String cityField;
  String zipCodeField;
  String reimbursementType;
  String userType;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userData, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBarColor,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              color: Colors.lightBlueAccent,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 1000),
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
                        child: Text(
                      'Register',
                      style: kTitleStyle,
                    )),
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
                          if ((passwordfield != null) && (emailField != null)) {
                            try {
                              await _auth.createUserWithEmailAndPassword(
                                  email: emailField, password: passwordfield);
                              currentUser = await _auth.currentUser();
                              //  Navigator.popAndPushNamed(context, Routes.submitReimbursement);
                            } catch (e) {
                              print(e);
                            }

                            userData.registerUser(
                                email: currentUser.email,
                                payMeBy: reimbursementType,
                                address: addressField,
                                zipCode: zipCodeField,
                                state: stateField,
                                city: cityField,
                                userType: userType);
                            Navigator.popAndPushNamed(
                                context, Routes.mainTabBar);
                          }
                        }),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
