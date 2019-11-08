import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reimbursement/model/user.dart';

class ProfileScreen extends StatelessWidget {

  FirebaseAuth _auth = FirebaseAuth.instance;




  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context,userData,child){
      return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                  padding: EdgeInsets.all(60),
                  child: Text('Profile & Settings',style: kTitleStyle,)),
            ),
            CircleAvatar(radius: 85,child: Icon(Icons.photo_camera,size: 50,),),
            FlatButton(child: Text('Sign Out',style: kRegularText.copyWith(color: Colors.black54),),onPressed: ()async{
             await _auth.signOut();
              Navigator.pop(context);
            },),
            SizedBox(height: 10,),
            Text('${userData.currentUserEmail}',style: kSubHeadingText,),
            SizedBox(height: 40,),
            Column(children: <Widget>[
              Text('Address:',style: kSubTitleText,),
              SizedBox(height: 10,),
              Text('   ${userData.address}\n   ${userData.city} ${userData.state}, ${userData.zipCode}',style: kRegularText,),
              SizedBox(height: 40,),
              Text('Payment Method:',style: kSubTitleText,),
              SizedBox(height: 10,),
              Text('   ${userData.paymentMethod.toUpperCase()}',style: kRegularText,),
              SizedBox(height: 40,),
              Text('User Type:',style: kSubTitleText,),
              SizedBox(height: 10,),
              Text('   ${userData.userType.toUpperCase()}',style: kRegularText,)

            ],)
          ],
        ),);
    },

    );
  }
}

