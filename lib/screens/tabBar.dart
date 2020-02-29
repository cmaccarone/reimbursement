import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/widgets.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar>
    with SingleTickerProviderStateMixin {
  FirebaseUser currentUser;
  TabController controller;
  String userType;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userType = Provider.of<UserProvider>(context).userType;
    currentUser = Provider.of<ReimbursementProvider>(context).currentUser;
    controller = TabController(
        initialIndex: 1, length: userType == "employee" ? 3 : 4, vsync: this);
  }

  @override
  void initState() {
    super.initState();
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
          tabs: userType == "employee"
              ? employeeTabs
              : userType == "admin" ? adminTabs : treasuryTabs,
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: userType == "employee"
            ? employeeScreens
            : userType == "admin" ? adminScreens : treasuryScreens,
      ),
    );
  }
}
