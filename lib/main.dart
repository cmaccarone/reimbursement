import 'package:flutter/material.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/screens/approve_screen.dart';
import 'package:reimbursement/screens/camera_view.dart';
import 'package:reimbursement/screens/profile_screen.dart';
import 'package:reimbursement/screens/tabBar.dart';
import 'screens/welcome.dart';
import 'routes.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/reset_password.dart';
import 'screens/submit_reimbursement.dart';
import 'screens/submitted_reimbursements.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/user.dart';
import 'package:camera/camera.dart';


 main() =>  runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider<User>(builder: (context) => User(),
       child: MaterialApp(
          darkTheme: ThemeData.dark(),
          routes: {
            Routes.welcomeScreen : (context) => WelcomeScreen(),
            Routes.loginScreen : (context) => LoginScreen(),
            Routes.registerScreen : (context) => RegisterScreen(),
            Routes.resetPasswordScreen : (context) => ResetPasswordScreen(),
            Routes.submitReimbursement : (context) => SubmitReimbursementScreen(),
            Routes.submittedReimbursements : (context) => SubmittedReimbursementScreen(),
            Routes.mainTabBar : (context) => MainTabBar(),
            Routes.approveReimbursement : (context) => ApproveScreen(),
            Routes.profileScreen : (context) => ProfileScreen(),
            Routes.camera : (context) => CameraScreen()
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
         home: WelcomeScreen(),
        ),
     );
    }
  }

