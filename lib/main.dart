import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/Request%20Approvals/receiptScreen.dart';
import 'package:reimbursement/screens/Request%20Approvals/requestApprovalScreen.dart';
import 'package:reimbursement/screens/approve/approve_screen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/routes.dart';
import 'package:reimbursement/screens/profile/profile_screen.dart';
import 'package:reimbursement/screens/reimburse/reimburseScreen.dart';

import 'screens/Completed/completedTripsScreen.dart';
import 'screens/Request Approvals/submit_reimbursement.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GestureDetector(
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
              Routes.submitReimbursement: (context) =>
                  SubmitReimbursementScreen(),
              Routes.mainTabBar: (context) => MainTabBar(),
              Routes.approveTripScreen: (context) => ApproveTripScreen(),
              Routes.profileScreen: (context) => ProfileScreen(),
              Routes.requestApprovalScreen: (context) =>
                  RequestApprovalScreen(),
              Routes.reimburseScreen: (context) => ReceiptScreen(),
              Routes.completedTrips: (context) => CompletedTripsScreen(),
              Routes.submitBug: (context) => SubmitBug(),
              Routes.tripDetailScreen: (context) => TripDetailScreen(),
              Routes.reimburseScreen: (context) => ReimburseScreen()
            },
            home: WelcomeScreen(),
            theme: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                textSelectionColor: kTabBarIconActive,
                primaryColor: kTabBarColor,
                accentColor: kAppbarColor,
                backgroundColor: kBackGroundColor,
                appBarTheme: AppBarTheme(
                  color: kTripCellColor,
                )),
          ),
        ),
      ),
    );
  }
}
