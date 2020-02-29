import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/model/my_custom_icons_icons.dart';
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
    super.initState();
    controller = TabController(initialIndex: 1, length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: kTabBarColor,
        child: TabBar(
          unselectedLabelStyle: TextStyle(color: kTabBarIconInactive),
          labelStyle: TextStyle(color: kTabBarIconActive),
          isScrollable: false,
          unselectedLabelColor: kTabBarIconInactive,
          indicatorWeight: 30,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0),
              width: 66,
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          controller: controller,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.person_outline,
              ),
            ),
            Tab(
              icon: Icon(Icons.attach_money),
            ),
            Tab(
              icon: Icon(Icons.list),
            ),
            Tab(
              icon: Icon(
                MyCustomIcons.account_cash__1_,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          ProfileScreen(),
          RequestApprovalScreen(),
          SubmittedReimbursementScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
