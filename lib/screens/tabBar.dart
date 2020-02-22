import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/screens/profile_screen.dart';
import 'package:reimbursement/screens/requestApprovalScreen.dart';

import 'profile_screen.dart';
import 'submitted_reimbursements.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar>
    with SingleTickerProviderStateMixin {
  FirebaseUser currentUser;
  TabController controller;

  @override
  void initState() {
    //todo: remove the code below on production (it just bypasses the login screen)

    // TODO: implement initState
    super.initState();
    controller = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
//todo: remove the code below on production (it just bypasses the login screen)

    //todo: end remove in production
    return Scaffold(
      bottomNavigationBar: TabBar(
        indicatorWeight: 20,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 80,
          ),
        ),
        indicatorColor: Colors.black45,
        indicatorSize: TabBarIndicatorSize.label,
        controller: controller,
        tabs: <Widget>[
          Tab(
            icon: Icon(
              Icons.person_outline,
              color: Colors.black45,
            ),
          ),
          Tab(
            icon: Icon(Icons.attach_money, color: Colors.black45),
          ),
          Tab(
            icon: Icon(Icons.list, color: Colors.black45),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          ProfileScreen(),
          RequestApprovalScreen(),
          SubmittedReimbursementScreen()
        ],
      ),
    );
  }
}
