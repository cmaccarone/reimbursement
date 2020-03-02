import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/my_custom_icons_icons.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/Completed/completedTripsScreen.dart';
import 'package:reimbursement/screens/Request Approvals/requestApprovalScreen.dart';
import 'package:reimbursement/screens/approve/approve_screen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/profile/profile_screen.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> with TickerProviderStateMixin {
  Key key = UniqueKey();
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

List<Widget> adminTabs = [
  Tab(
    key: UniqueKey(),
    icon: Icon(
      Icons.person_outline,
    ),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(Icons.attach_money),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(Icons.list),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(
      Icons.check,
    ),
  ),
];

List<Widget> treasuryTabs = [
  Tab(
    key: UniqueKey(),
    icon: Icon(
      Icons.person_outline,
    ),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(Icons.attach_money),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(Icons.list),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(
      MyCustomIcons.account_cash__1_,
    ),
  ),
];

List<Widget> employeeTabs = [
  Tab(
    key: UniqueKey(),
    icon: Icon(
      Icons.person_outline,
    ),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(Icons.attach_money),
  ),
  Tab(
    key: UniqueKey(),
    icon: Icon(Icons.list),
  ),
];

List<Widget> employeeScreens = [
  ProfileScreen(),
  RequestApprovalScreen(),
  CompletedTripsScreen(),
];

List<Widget> adminScreens = [
  ProfileScreen(),
  RequestApprovalScreen(),
  CompletedTripsScreen(),
  ApproveTripScreen()
];

List<Widget> treasuryScreens = [
  ProfileScreen(),
  RequestApprovalScreen(),
  CompletedTripsScreen(),
  ApproveTripScreen()
];
