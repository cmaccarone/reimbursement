import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/routes.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

class LoginScreen extends StatelessWidget {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailField;
  String passwordfield;
  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: kAppbarColor,
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(30),
        color: Colors.lightBlueAccent,
        child: ConstrainedScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
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
              'Sign In',
              style: kTitleStyle,
            )),
            SizedBox(
              height: 10,
            ),
            SignInTextFields(
              KeyboardType: TextInputType.emailAddress,
              controller: emailController,
              autoFocusEnabled: true,
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
              controller: passwordController,
              autoFocusEnabled: true,
              inputLabel: 'Password',
              hideText: true,
              onChanged: (newValue) {
                passwordfield = newValue;
                print(newValue);
              },
            ),
            SizedBox(
              height: 10,
            ),
            SubmitButton(
                label: 'Login',
                onTapped: () async {
                  print('$emailField and $passwordfield');
                  if ((passwordfield != null) && (emailField != null)) {
                    try {
                      await _auth
                          .signInWithEmailAndPassword(
                              email: emailField, password: passwordfield)
                          .then((AuthResult auth) async {
                        print("auth: ${auth.user.email}");
                        if (auth != null) {
                          await getUserData(context);
                        }
                      });
                    } catch (e) {
                      print(e);
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<void> getUserData(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false)
        .getUserDataOnLogin();

    Provider.of<ReimbursementProvider>(context, listen: false)
        .initStreams(context: context);

    Navigator.pushNamed(context, Routes.mainTabBar);
  }
}
