import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/approve_screen.dart';
import 'package:reimbursement/screens/cameraPreviewScreen.dart';
import 'package:reimbursement/screens/profile_screen.dart';
import 'package:reimbursement/screens/tabBar.dart';

import 'routes.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/reset_password.dart';
import 'screens/submit_reimbursement.dart';
import 'screens/submitted_reimbursements.dart';
import 'screens/welcome.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<ReimbursementProvider>(
            create: (context) => ReimbursementProvider())
      ],
      child: MaterialApp(
        routes: {
          Routes.welcomeScreen: (context) => WelcomeScreen(),
          Routes.loginScreen: (context) => LoginScreen(),
          Routes.registerScreen: (context) => RegisterScreen(),
          Routes.resetPasswordScreen: (context) => ResetPasswordScreen(),
          Routes.submitReimbursement: (context) => SubmitReimbursementScreen(),
          Routes.submittedReimbursements: (context) =>
              SubmittedReimbursementScreen(),
          Routes.mainTabBar: (context) => MainTabBar(),
          Routes.approveReimbursement: (context) => ApproveScreen(),
          Routes.profileScreen: (context) => ProfileScreen(),
          Routes.cameraPreviewScreen: (context) => CameraPreviewScreen()
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
