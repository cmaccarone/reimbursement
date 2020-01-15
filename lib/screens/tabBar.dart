import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/screens/profile_screen.dart';
import 'profile_screen.dart';
import 'submit_reimbursement.dart';
import 'submitted_reimbursements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/user.dart';
import 'package:reimbursement/model/databaseFields.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> with SingleTickerProviderStateMixin {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  TabController controller;



  void signin() async {
    try {
      await _auth.signInWithEmailAndPassword(email: "admin@2.com",
          password: "fdjkas");
      currentUser = await _auth.currentUser();
    }
    catch (e) {
      print(e);
    }
  }



  @override void initState() {
   //todo: remove the code below on production (it just bypasses the login screen)


    // TODO: implement initState
    super.initState();
     controller = TabController(initialIndex: 1,length: 3,vsync: this);
  }

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }




  @override
  Widget build(BuildContext context) {
//todo: remove the code below on production (it just bypasses the login screen)


    WidgetsBinding.instance.addPostFrameCallback((_)=> signin());
    print(currentUser.email);
    return Consumer<User>(builder: (context,userData,child){
      void updateData() async {

        //todo: remove in production begin
        final data = await Firestore.instance.collection('users').document(currentUser.uid).get();
        userData.updateData(

            payMeBy: data.data[UserFields.payMeBy],
            email: data.data[UserFields.email],
            address: data.data[UserFields.address],
            city: data.data[UserFields.city],
            state: data.data[UserFields.state],
            zipCode: data.data[UserFields.zipCode],
            userType: data.data[UserFields.userType]
        );
      }

      updateData();

      //todo: end remove in production
      return Scaffold(
        bottomNavigationBar: TabBar(
          indicatorWeight: 20,
          indicator:  UnderlineTabIndicator(borderSide: BorderSide(color: Colors.blueGrey,width: 80,),),
          indicatorColor: Colors.black45,
          indicatorSize: TabBarIndicatorSize.label,
          controller: controller,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.person_outline,color: Colors.black45,),),
            Tab(icon: Icon(Icons.attach_money,color: Colors.black45),),
            Tab(icon: Icon(Icons.list,color: Colors.black45),),

          ],
        ),
        body: TabBarView(
          controller: controller,
        children: <Widget>[
          ProfileScreen(),
          SubmitReimbursementScreen(),
          SubmittedReimbursementScreen()
        ],),
      );
    },
    );
  }
}

