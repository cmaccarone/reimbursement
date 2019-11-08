import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/screens/profile_screen.dart';
import 'profile_screen.dart';
import 'submit_reimbursement.dart';
import 'submitted_reimbursements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> with SingleTickerProviderStateMixin {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  TabController controller;

  @override void initState() {
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
  }
}

