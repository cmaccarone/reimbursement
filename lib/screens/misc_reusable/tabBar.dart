import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/my_custom_icons_icons.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/Completed/completedTripsScreen.dart';
import 'package:reimbursement/screens/approve/approve_screen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/profile/profile_screen.dart';
import 'package:reimbursement/screens/reimburse/reimburseScreen.dart';
import 'package:reimbursement/screens/request_approvals/requestApprovalScreen.dart';

final _profile = GlobalKey<NavigatorState>();
final _submit = GlobalKey<NavigatorState>();
final _completed = GlobalKey<NavigatorState>();
final _approve = GlobalKey<NavigatorState>();
final _reimburse = GlobalKey<NavigatorState>();

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> with TickerProviderStateMixin {
  FirebaseUser currentUser;
  TabController controller;
  String userType;
  int currentTabIndex = 1;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(kTabBarColor);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          child: IndexedStack(
            index: currentTabIndex,
            children: userType == Users.employee
                ? employeeScreens
                : userType == Users.treasury
                    ? treasuryScreens
                    : userType == Users.admin ? adminScreens : superScreens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: kTabBarIconInactive,
          selectedItemColor: kTabBarIconActive,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTabIndex,
          onTap: (val) => _onTap(val, context),
          backgroundColor: kTabBarColor,
          items: userType == Users.employee
              ? employeeTabs
              : userType == Users.treasury
                  ? treasuryTabs
                  : userType == Users.admin ? adminTabs : superTabs,
        ),
      ),
    );
  }

  void _onTap(int val, BuildContext context) {
    if (currentTabIndex == val) {
      switch (val) {
        case 0:
          _profile.currentState.popUntil((route) => route.isFirst);
          break;
        case 1:
          _submit.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _completed.currentState.popUntil((route) => route.isFirst);
          break;
        case 3:
          _approve.currentState.popUntil((route) => route.isFirst);
          break;
        case 4:
          _reimburse.currentState.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          currentTabIndex = val;
        });
      }
    }
  }
}

List<BottomNavigationBarItem> adminTabs = [
  BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outline,
      ),
      title: Text("Profile")),
  BottomNavigationBarItem(
      icon: Icon(Icons.attach_money), title: Text("Request")),
  BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Completed")),
  BottomNavigationBarItem(
      icon: Icon(
        Icons.check,
      ),
      title: Text("Approve")),
];

List<BottomNavigationBarItem> treasuryTabs = [
  BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outline,
      ),
      title: Text("Profile")),
  BottomNavigationBarItem(
      icon: Icon(Icons.attach_money), title: Text("Request")),
  BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Completed")),
  BottomNavigationBarItem(
      icon: Icon(
        MyCustomIcons.account_cash__1_,
      ),
      title: Text("Reimburse")),
];

List<BottomNavigationBarItem> superTabs = [
  BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outline,
      ),
      title: Text("Profile")),
  BottomNavigationBarItem(
      icon: Icon(Icons.attach_money), title: Text("Request")),
  BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Completed")),
  BottomNavigationBarItem(
      icon: Icon(
        Icons.check,
      ),
      title: Text("Approve")),
  BottomNavigationBarItem(
      icon: Icon(
        MyCustomIcons.account_cash__1_,
      ),
      title: Text("Reimburse")),
];

List<BottomNavigationBarItem> employeeTabs = [
  BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outline,
      ),
      title: Text("Profile")),
  BottomNavigationBarItem(
      icon: Icon(Icons.attach_money), title: Text("Request")),
  BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Completed")),
];

List<Widget> employeeScreens = [
  Navigator(
    key: _profile,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ProfileScreen(),
    ),
  ),
  Navigator(
    key: _submit,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => RequestApprovalScreen(),
    ),
  ),
  Navigator(
    key: _completed,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => CompletedTripsScreen(),
    ),
  ),
];

List<Widget> adminScreens = [
  Navigator(
    key: _profile,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ProfileScreen(),
    ),
  ),
  Navigator(
    key: _submit,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => RequestApprovalScreen(),
    ),
  ),
  Navigator(
    key: _completed,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => CompletedTripsScreen(),
    ),
  ),
  Navigator(
    key: _approve,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ApproveTripScreen(),
    ),
  ),
];

List<Widget> treasuryScreens = [
  Navigator(
    key: _profile,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ProfileScreen(),
    ),
  ),
  Navigator(
    key: _submit,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => RequestApprovalScreen(),
    ),
  ),
  Navigator(
    key: _completed,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => CompletedTripsScreen(),
    ),
  ),
  Navigator(
    key: _reimburse,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ReimburseScreen(),
    ),
  ),
];

List<Widget> superScreens = [
  Navigator(
    key: _profile,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ProfileScreen(),
    ),
  ),
  Navigator(
    key: _submit,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => RequestApprovalScreen(),
    ),
  ),
  Navigator(
    key: _completed,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => CompletedTripsScreen(),
    ),
  ),
  Navigator(
    key: _approve,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ApproveTripScreen(),
    ),
  ),
  Navigator(
    key: _reimburse,
    onGenerateRoute: (route) => MaterialPageRoute(
      settings: route,
      builder: (context) => ReimburseScreen(),
    ),
  ),
];
