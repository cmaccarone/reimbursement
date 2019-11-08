import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reimbursement/routes.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/model/user.dart';

class LoginScreen extends StatelessWidget {

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final controller = TextEditingController();
  String emailField;
  String passwordfield;
  FirebaseUser currentUser;

  void getData() async {


  }
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context,userData,child){
      return Scaffold(
        appBar: AppBar(backgroundColor: kAppBarColor,),
        body: Container(
          padding: EdgeInsets.all(30),
          color: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                  tag: 'dollar',
                  child: CircleAvatar(child: Icon(Icons.attach_money,size: 60,color: Colors.white,),radius: 40,backgroundColor: Colors.greenAccent,)),
              SizedBox(height: 20,),
              Center(child: Text('Sign In',style: kTitleStyle,)),
              SizedBox(height: 10,),
              SignInTextFields(inputText: 'Email',hideText: false,onChanged: (newValue){
                emailField = newValue;
              },),
              SizedBox(height: 10,),
              SignInTextFields(inputText: 'Password',hideText: true,onChanged: (newValue){
                passwordfield = newValue;
                print(newValue);
              },),
              SizedBox(height: 10,),
              SubmitButton(label: 'Login', onTapped: () async {
                print('$emailField and $passwordfield');
                if ((passwordfield != null) && (emailField != null)) {
                  try {

                    await _auth.signInWithEmailAndPassword(email: emailField,
                        password: passwordfield);
                  currentUser = await _auth.currentUser();

                   } catch (e) {
                    print(e);
                  }
                  final data = await _firestore.collection('users').document(currentUser.uid).get();
                  print(data.data);
                  userData.updateData(

                      payMeBy: data.data[UserFields.payMeBy],
                     email: data.data[UserFields.email],
                    address: data.data[UserFields.address],
                      city: data.data[UserFields.city],
                      state: data.data[UserFields.state],
                      zipCode: data.data[UserFields.zipCode],
                      userType: data.data[UserFields.userType]
                  );

                 Navigator.popAndPushNamed(context, Routes.mainTabBar);

                }

              }
              ),

            ],),
        ),
      );
    },
    );
  }
}

