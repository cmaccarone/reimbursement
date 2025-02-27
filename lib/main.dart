import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/firebase_reimbursement_provider.dart';
import 'package:reimbursement/providers/firebase_userData.dart';
import 'package:reimbursement/screens/approve/approve_screen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/routes.dart';
import 'package:reimbursement/screens/profile/profile_screen.dart';
import 'package:reimbursement/screens/reimburse/reimburseScreen.dart';
import 'package:reimbursement/screens/request_approvals/ReviewReceiptScreen.dart';
import 'package:reimbursement/screens/request_approvals/receiptScreen.dart';
import 'package:reimbursement/screens/request_approvals/requestApprovalScreen.dart';

import 'screens/Completed/completedTripsScreen.dart';
import 'screens/SignIn/login.dart';
import 'screens/SignIn/register.dart';
import 'screens/SignIn/reset_password.dart';
import 'screens/SignIn/welcome.dart';
import 'screens/approve/tripDetailScreen.dart';
import 'screens/misc_reusable/tabBar.dart';
import 'screens/profile/SubmitBug.dart';

final GlobalKey<NavigatorState> key = GlobalKey();

main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MultiProvider(
        providers: [
          Provider<UserProvider>(create: (context) => UserProvider()),
          Provider<ReimbursementProvider>(
              create: (context) => ReimbursementProvider())
        ],
        child: MaterialApp(
          navigatorKey: key,
          routes: {
            Routes.welcomeScreen: (context) => WelcomeScreen(),
            Routes.loginScreen: (context) => LoginScreen(),
            Routes.registerScreen: (context) => RegisterScreen(),
            Routes.resetPasswordScreen: (context) => ResetPasswordScreen(),
            Routes.mainTabBar: (context) => MainTabBar(),
            Routes.approveTripScreen: (context) => ApproveTripScreen(),
            Routes.profileScreen: (context) => ProfileScreen(),
            Routes.requestApprovalScreen: (context) => RequestApprovalScreen(),
            Routes.reimburseScreen: (context) => ReceiptScreen(),
            Routes.completedTrips: (context) => CompletedTripsScreen(),
            Routes.submitBug: (context) => SubmitBug(),
            Routes.tripDetailScreen: (context) => TripDetailScreen(),
            Routes.reimburseScreen: (context) => ReimburseScreen(),
            Routes.reviewReceiptScreen: (context) => ReviewReceiptScreen()
          },
          home: WelcomeScreen(),
          themeMode: ThemeMode.light,
          theme: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              textSelectionColor: kTabBarIconActive,
              primaryColor: kTabBarColor,
              accentColor: kAppbarColor,
              backgroundColor: kBackGroundColor,
              primaryColorBrightness: Brightness.dark,
              appBarTheme: AppBarTheme(
                brightness: Brightness.dark,
              )),
          darkTheme: ThemeData(
              primaryColor: Colors.black,
              primaryColorBrightness: Brightness.dark,
              primaryColorLight: Colors.black,
              brightness: Brightness.dark,
              primaryColorDark: Colors.black,
              indicatorColor: Colors.white,
              canvasColor: Colors.black,
              // next line is important!
              appBarTheme: AppBarTheme(brightness: Brightness.dark)),
        ),
      ),
    );
  }
}
